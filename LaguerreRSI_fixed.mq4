//+------------------------------------------------------------------+
//|                                              LaguerreRSI_fixed.mq4 |
//|                          a variation on the Laguerre RSI theme    |
//|                   solves some problems with low lag smoothing     |
//|              Original author: mladen / Modified: Koma 2026        |
//|              Removed license restriction and auth checks          |
//+------------------------------------------------------------------+
// 【修正概要】
// ライセンス機構・認証機能（auth関数）を完全削除
// アルゴリズムは変更なし（Laguerreフィルタ + RSI計算）
//+------------------------------------------------------------------+

#property copyright "Original: mladen / Modified: Koma"
#property link      "https://www.komashikifx.site"
#property version   "1.01"
#property strict
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1  LimeGreen
#property indicator_color2  Orange
#property indicator_color3  Orange
#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  2

//--- 価格種別の列挙型
enum prices
{
   pr_close,   // Close
   pr_open,    // Open
   pr_high,    // High
   pr_low,     // Low
   pr_median,  // Median
   pr_typical, // Typical
   pr_weighted // Weighted
};

//--- 外部パラメータ
extern double LaguerreGamma   = 0.55;   // Laguerreフィルタ係数
extern prices LaguerrePrice   = pr_weighted;  // 価格種別
extern int    RSIDataLevel    = 0;      // RSI計算レベル (0=L0-L1, 1=L1-L2, 2=L2-L3)
extern int    RSIPeriod       = 2;      // RSI計算期間
extern bool   Smooth          = true;   // スムージング有効
extern bool   alertsOn        = true;
extern bool   alertsOnCurrent = false;
extern bool   alertsMessage   = true;
extern bool   alertsSound     = false;
extern bool   alertsNotify    = false;
extern bool   alertsEmail     = false;
extern string soundFile       = "alert2.wav";

//--- バッファ定義
double RSI[];
double RSIda[];
double RSIdb[];
double L0[];
double L1[];
double L2[];
double L3[];
double LR[];
double slope[];

string indicator_name = "";

//+------------------------------------------------------------------+
//| 初期化                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- バッファ定義
   IndicatorBuffers(9);
   SetIndexBuffer(0, RSI);   SetIndexLabel(0, "Laguerre RSI");
   SetIndexBuffer(1, RSIda); SetIndexLabel(1, "Laguerre RSI");
   SetIndexBuffer(2, RSIdb); SetIndexLabel(2, "Laguerre RSI");
   SetIndexBuffer(3, L0);
   SetIndexBuffer(4, L1);
   SetIndexBuffer(5, L2);
   SetIndexBuffer(6, L3);
   SetIndexBuffer(7, LR);
   SetIndexBuffer(8, slope);

   //--- パラメータ検証
   RSIDataLevel = MathMax(MathMin(RSIDataLevel, 2), 0);

   //--- インジケータ名
   IndicatorShortName("LaguerreRSI_fixed (" + DoubleToStr(LaguerreGamma, 2) + "," +
                      (string)RSIDataLevel + "," + (string)RSIPeriod + ")");
   indicator_name = "LaguerreRSI_fixed (" + DoubleToStr(LaguerreGamma, 2) + "," +
                    (string)RSIDataLevel + "," + (string)RSIPeriod + ")";

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| 解放処理                                                         |
//+------------------------------------------------------------------+
int OnDeinit(const int reason)
{
   return(0);
}

//+------------------------------------------------------------------+
//| メイン計算関数                                                    |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int counted_bars = IndicatorCounted();
   int i, limit;

   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;

   limit = MathMin(Bars - counted_bars, Bars - 1 - RSIPeriod - 2);

   //================================================================
   // 【Laguerreフィルタ＋RSI計算】
   //
   // ステップ1: Laguerreフィルタ（4段階）
   //   γ=0.55（バランス値）
   //   L0,L1,L2,L3で順次スムージング
   //
   // ステップ2: RSI計算
   //   期間内のdiff（差分）を合計
   //   cu = 正の差分の合計
   //   cd = 負の差分の合計（絶対値）
   //   RSI = 0.5 * ((cu-cd)/(cu+cd) + 1)
   //   → 0.0 ～ 1.0の正規化RSI
   //
   // ステップ3: スムージング（3-bar加重平均）
   //   RSI[i] = (LR[i] + 2*LR[i+1] + LR[i+2]) / 4
   //================================================================

   if(slope[limit] == -1)
      ClearPoint(limit, RSIda, RSIdb);

   for(i = limit; i >= 0; i--)
   {
      //--- 価格取得
      double Price = iMA(NULL, 0, 1, 0, MODE_SMA, (int)LaguerrePrice, i);

      //--- Laguerreフィルタ計算（4段階）
      L0[i] = (1.0 - LaguerreGamma) * Price + LaguerreGamma * L0[i + 1];
      L1[i] = -LaguerreGamma * L0[i] + L0[i + 1] + LaguerreGamma * L1[i + 1];
      L2[i] = -LaguerreGamma * L1[i] + L1[i + 1] + LaguerreGamma * L2[i + 1];
      L3[i] = -LaguerreGamma * L2[i] + L2[i + 1] + LaguerreGamma * L3[i + 1];

      //--- RSI計算
      double cu = 0;
      double cd = 0;
      for(int k = 0; k < RSIPeriod; k++)
      {
         double diff = 0;
         switch(RSIDataLevel)
         {
            case 0: diff = L0[i + k] - L1[i + k]; break;
            case 1: diff = L1[i + k] - L2[i + k]; break;
            case 2: diff = L2[i + k] - L3[i + k]; break;
         }
         if(diff > 0) cu += diff;
         if(diff < 0) cd -= diff;
      }

      //--- RSI値の計算（0.0～1.0に正規化）
      if((cu + cd) != 0)
      {
         LR[i] = 0.5 * ((cu - cd) / (cu + cd) + 1);
      }
      else
      {
         LR[i] = 0;
      }

      //--- スムージング処理
      if(Smooth)
      {
         RSI[i] = (LR[i] + 2.0 * LR[i + 1] + LR[i + 2]) / 4.0;
      }
      else
      {
         RSI[i] = LR[i];
      }

      //--- スロープ判定
      slope[i] = slope[i + 1];
      if(RSI[i] > RSI[i + 1])
         slope[i] = 1;
      if(RSI[i] < RSI[i + 1])
         slope[i] = -1;

      if(slope[i] == -1)
         PlotPoint(i, RSIda, RSIdb, RSI);
   }

   //--- アラート処理
   if(alertsOn)
   {
      int whichBar = 0;
      if(alertsOnCurrent)
         whichBar = 0;
      else
         whichBar = 1;

      if(slope[whichBar] != slope[whichBar + 1])
      {
         if(slope[whichBar] == 1)
         {
            doAlert("sloping up");
         }
         else
         {
            doAlert("sloping down");
         }
      }
   }

   return(rates_total);
}

//+------------------------------------------------------------------+
//| ポイントクリア関数                                               |
//+------------------------------------------------------------------+
void ClearPoint(int i, double& first[], double& second[])
{
   if((second[i] != EMPTY_VALUE) && (second[i + 1] != EMPTY_VALUE))
      second[i + 1] = EMPTY_VALUE;
   else if((first[i] != EMPTY_VALUE) && (first[i + 1] != EMPTY_VALUE) && (first[i + 2] == EMPTY_VALUE))
      first[i + 1] = EMPTY_VALUE;
}

//+------------------------------------------------------------------+
//| ポイントプロット関数                                             |
//+------------------------------------------------------------------+
void PlotPoint(int i, double& first[], double& second[], double& from[])
{
   if(first[i + 1] == EMPTY_VALUE)
   {
      if(first[i + 2] == EMPTY_VALUE)
      {
         first[i] = from[i];
         first[i + 1] = from[i + 1];
         second[i] = EMPTY_VALUE;
      }
      else
      {
         second[i] = from[i];
         second[i + 1] = from[i + 1];
         first[i] = EMPTY_VALUE;
      }
   }
   else
   {
      first[i] = from[i];
      second[i] = EMPTY_VALUE;
   }
}

//+------------------------------------------------------------------+
//| アラート送信関数                                                 |
//+------------------------------------------------------------------+
void doAlert(string doWhat)
{
   static string   previousAlert = "nothing";
   static datetime previousTime;
   string message;

   if(previousAlert != doWhat || previousTime != Time[0])
   {
      previousAlert = doWhat;
      previousTime = Time[0];

      message = StringConcatenate(Symbol(), " at ", TimeToStr(TimeLocal(), TIME_SECONDS),
                                  " Laguerre RSI ", doWhat);
      if(alertsMessage)
      {
         Alert(message);
      }
      if(alertsNotify)
      {
         SendNotification(message);
      }
      if(alertsEmail)
      {
         SendMail(StringConcatenate(Symbol(), " Laguerre RSI"), message);
      }
      if(alertsSound)
      {
         PlaySound(soundFile);
      }
   }
}
//+------------------------------------------------------------------+
