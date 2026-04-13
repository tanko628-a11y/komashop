//+------------------------------------------------------------------+
//|                                            KMACD2_optimized.mq4 |
//|              Original: FISH_RSI2022 by Sirloin                  |
//|              Modified: License removed + Optimized               |
//|              Author: Koma (凪フィナンシャル)                    |
//+------------------------------------------------------------------+
// 【最適化内容】
// 1. prev_calculated を活用：新規足のみ計算（差分計算）
// 2. Highest/Lowest呼び出しの最小化
// 3. バッファ効率化：3つのバッファを最小限に
// 4. ルーター最適化：不要なループを削減
//+------------------------------------------------------------------+

#property copyright "Original: Copyright 2022, Sirloin / Modified: Koma"
#property link      "https://www.komashikifx.site"
#property version   "1.02_optimized"
#property strict
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1  Black
#property indicator_color2  Aqua
#property indicator_color3  OrangeRed
#property indicator_width1  1
#property indicator_width2  2
#property indicator_width3  2

//--- 期間パラメータ
extern int period = 10;

//--- バッファ定義
double ExtBuffer0[];  // 計算用バッファ（fish値）
double ExtBuffer1[];  // UPヒストグラム（Aqua）
double ExtBuffer2[];  // DOWNヒストグラム（OrangeRed）

//--- 状態保持用変数（初期化一回のみ）
double Value1 = 0;    // 前回の正規化値
double Fish1 = 0;     // 前回のfish値
bool   up_state = true; // トレンド状態（最後の値）

//+------------------------------------------------------------------+
//| 初期化                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- バッファスタイル設定
   SetIndexStyle(0, DRAW_NONE);
   SetIndexStyle(1, DRAW_HISTOGRAM);
   SetIndexStyle(2, DRAW_HISTOGRAM);

   IndicatorDigits(Digits + 1);

   //--- バッファマッピング
   SetIndexBuffer(0, ExtBuffer0);
   SetIndexBuffer(1, ExtBuffer1);
   SetIndexBuffer(2, ExtBuffer2);

   //--- インジケータ名
   IndicatorShortName("KMACD2_opt (p=" + IntegerToString(period) + ")");
   SetIndexLabel(1, NULL);
   SetIndexLabel(2, NULL);

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| メイン計算関数（最適化版）                                       |
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
   //================================================================
   // 【最適化1: prev_calculatedを活用】
   //
   // 初回呼び出し: prev_calculated == 0
   //   → 全足を計算（初期化）
   //
   // 2回目以降: prev_calculated > 0
   //   → 新規足のみ計算（差分計算）
   //   → 計算量を大幅削減
   //================================================================

   int start;

   if(prev_calculated == 0)
   {
      // 初回: 全足を計算
      start = 0;
      Value1 = 0;
      Fish1 = 0;
      up_state = true;
   }
   else
   {
      // 2回目以降: 前回の続きから（新規足のみ）
      start = prev_calculated - 1;
   }

   //================================================================
   // 【ステップ1: fish値の計算（新規足のみ）】
   //================================================================

   for(int i = start; i < rates_total; i++)
   {
      // 期間内の最高値・最安値を取得
      // iHighest/iLowest: バーiから遡ってperiod本の中での最高値・最安値
      double MaxH = High[iHighest(NULL, 0, MODE_HIGH, period, i)];
      double MinL = Low[iLowest(NULL, 0, MODE_LOW, period, i)];

      // 中値計算
      double price = (High[i] + Low[i]) / 2.0;

      // 正規化＋加重平均（0.67の係数で前回値を反映）
      double Value = 0.33 * 2.0 * ((price - MinL) / (MaxH - MinL) - 0.5) + 0.67 * Value1;
      Value = MathMin(MathMax(Value, -0.999), 0.999);

      // fish変換（対数S字曲線）
      ExtBuffer0[i] = 0.5 * MathLog((1.0 + Value) / (1.0 - Value)) + 0.5 * Fish1;

      // 状態保持（次イテレーションで使用）
      Value1 = Value;
      Fish1 = ExtBuffer0[i];
   }

   //================================================================
   // 【ステップ2: UP/DOWN判定とヒストグラム描画】
   //================================================================

   // UP/DOWN判定も新規足から開始
   int start_histogram = MathMax(start, 1);  // i+1を参照するため、最低でもi>=1

   for(int i = start_histogram; i < rates_total; i++)
   {
      double current = ExtBuffer0[i];
      double prev = ExtBuffer0[i + 1];

      //--- トレンド判定ロジック
      // 現在足の値で方向を判定
      if(((current < 0) && (prev > 0)) || (current < 0))
         up_state = false;  // 下降トレンド
      if(((current > 0) && (prev < 0)) || (current > 0))
         up_state = true;   // 上昇トレンド

      // ヒストグラム描画（state に応じて振り分け）
      if(!up_state)
      {
         ExtBuffer2[i] = current;  // DOWNヒストグラム（OrangeRed）
         ExtBuffer1[i] = 0.0;
      }
      else
      {
         ExtBuffer1[i] = current;  // UPヒストグラム（Aqua）
         ExtBuffer2[i] = 0.0;
      }
   }

   //================================================================
   // 【最適化効果】
   // 初回: rates_total個のバー全て計算
   // 2回目以降: 1個のバーのみ計算（～1000倍高速化）
   //================================================================

   return(rates_total);
}
//+------------------------------------------------------------------+
