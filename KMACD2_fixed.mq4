//+------------------------------------------------------------------+
//|                                                 KMACD2_fixed.mq4 |
//|              Original: FISH_RSI2022 by Sirloin                  |
//|              Modified: Removed license restriction               |
//|              Author: Koma (凪フィナンシャル)                    |
//+------------------------------------------------------------------+
// 【修正概要】
// ライセンス制限・期限チェック・口座IDホワイトリスト を完全削除
// アルゴリズムは変更なし（フィッシュオシレータの純粋実装）
//+------------------------------------------------------------------+

#property copyright "Original: Copyright 2022, Sirloin / Modified: Koma"
#property link      "https://www.komashikifx.site"
#property version   "1.01"
#property strict
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1  Black
#property indicator_color2  Aqua
#property indicator_color3  OrangeRed
#property indicator_width1  1
#property indicator_width2  2
#property indicator_width3  2

//--- 期間パラメータ（最適化用）
extern int period = 10;

//--- バッファ定義
double ExtBuffer0[];  // 計算用バッファ（非表示）
double ExtBuffer1[];  // UPヒストグラム（Aqua）
double ExtBuffer2[];  // DOWNヒストグラム（OrangeRed）

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
   IndicatorShortName("KMACD2 (period=" + IntegerToString(period) + ")");
   SetIndexLabel(1, NULL);
   SetIndexLabel(2, NULL);

   return(INIT_SUCCEEDED);
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
   double prev, current;
   double Value = 0, Value1 = 0;
   double Fish = 0, Fish1 = 0;
   double price;
   double MinL = 0;
   double MaxH = 0;

   //--- 計算開始位置の決定
   if(counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;

   //================================================================
   // 【フィッシュオシレータの計算】
   //
   // ステップ1: 期間内の最高値・最安値を取得
   //   MaxH = Highest(High, period, i)
   //   MinL = Lowest(Low, period, i)
   //
   // ステップ2: 価格を0-1に正規化
   //   price = (High[i] + Low[i]) / 2
   //   Value = 0.33*2*((price-MinL)/(MaxH-MinL)-0.5) + 0.67*Value1
   //
   // ステップ3: フィッシュ変換（対数S字曲線）
   //   Fish = 0.5*Log((1+Value)/(1-Value)) + 0.5*Fish1
   //
   // ステップ4: UP/DOWN判定
   //   Fish > 0 → UP
   //   Fish < 0 → DOWN
   //================================================================

   //--- ステップ1-3: フィッシュ値の計算
   for(int i = 0; i < limit; i++)
   {
      // 期間内の最高値・最安値
      MaxH = High[Highest(NULL, 0, MODE_HIGH, period, i)];
      MinL = Low[Lowest(NULL, 0, MODE_LOW, period, i)];

      // 中値
      price = (High[i] + Low[i]) / 2.0;

      // 正規化＋加重平均
      Value = 0.33 * 2.0 * ((price - MinL) / (MaxH - MinL) - 0.5) + 0.67 * Value1;
      Value = MathMin(MathMax(Value, -0.999), 0.999);

      // フィッシュ変換
      ExtBuffer0[i] = 0.5 * MathLog((1.0 + Value) / (1.0 - Value)) + 0.5 * Fish1;

      Value1 = Value;
      Fish1 = ExtBuffer0[i];
   }

   //--- ステップ4: UP/DOWN判定およびヒストグラム描画
   bool up = true;
   for(int i = limit - 2; i >= 0; i--)
   {
      current = ExtBuffer0[i];
      prev = ExtBuffer0[i + 1];

      // トレンド方向の判定
      if(((current < 0) && (prev > 0)) || (current < 0))
         up = false;
      if(((current > 0) && (prev < 0)) || (current > 0))
         up = true;

      // ヒストグラム描画
      if(!up)
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

   return(rates_total);
}
//+------------------------------------------------------------------+
