//+------------------------------------------------------------------+
//|                                                   karrows7_fixed.mq4 |
//|              Modified by Koma (コマ式FX練成会) 2026             |
//|              Fix 1: Eliminated future-reference (repainting)      |
//|              Fix 2: Corrected signal logic (rsi_prev == 1 issue)  |
//|              Fix 3: Removed license restriction                  |
//+------------------------------------------------------------------+
// 【修正概要】
// Fix 1: rsi01 に shift=i-1（未来バー）を使用していたためリペイント発生
//        → rsi01 に shift=i+1（1本前の過去バー）を使用し未来参照を排除
// Fix 2: rsi_prev == 1 という厳しすぎる条件（ほぼ発生しない）
//        → fish値の強度を基準に修正（推奨案C）
// Fix 3: ライセンス制限・有効期限・口座IDホワイトリスト
//        → すべて削除し、フリー配布可能に
//+------------------------------------------------------------------+

#property copyright "Original: Copyright 2022, Sirloin / Modified: Koma"
#property link      "https://www.komashikifx.site"
#property version   "1.02"
#property strict
#property indicator_chart_window

#property indicator_buffers 2
#property indicator_color1  clrBlue
#property indicator_color2  clrRed
#property indicator_width1  2
#property indicator_width2  2

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
extern int    period_KMACD = 10;
extern double AAA          = 0.55;
extern prices BBB          = pr_weighted;
extern int    CCC          = 0;
extern int    DDD          = 2;
extern bool   EEE          = true;

//--- シグナル条件のパラメータ（最適化用）
extern double fish_threshold_up   = 0.1;   // UP条件: fish > this
extern double fish_threshold_down = -0.1;  // DOWN条件: fish < this
extern double rsi_threshold_up    = 0.5;   // UP条件: rsi > this
extern double rsi_threshold_down  = 0.5;   // DOWN条件: rsi < this

//--- Laguerre_rsi_variation_K へ渡すアラート設定（OFFで渡す）
bool   alertsOn        = false;
bool   alertsOnCurrent = false;
bool   alertsMessage   = false;
bool   alertsSound     = false;
bool   alertsNotify    = false;
bool   alertsEmail     = false;

//--- このインジ自身のアラート設定
extern bool alertsOn_k6        = true;
extern bool alertsOnCurrent_k6 = false;  // true=現在足でもアラート（リペイント注意）
extern bool alertsMessage_k6   = true;
extern bool alertsSound_k6     = true;
extern bool alertsNotify_k6    = true;
extern bool alertsEmail_k6     = true;
string soundFile = "alert2.wav";

//--- インジケータバッファ
double arrEntUp[];    // UPシグナル（青矢印）
double arrEntDown[];  // DOWNシグナル（赤矢印）

int    maxlimit      = 1500; // 計算する最大バー数
string indicator_name = "karrows7_fixed";

//+------------------------------------------------------------------+
//| 初期化                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   Comment("");

   //--- バッファ設定
   IndicatorBuffers(2);
   SetIndexBuffer(0, arrEntUp);
   SetIndexBuffer(1, arrEntDown);

   //--- 矢印スタイル設定（233=上矢印, 234=下矢印）
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID);
   SetIndexStyle(1, DRAW_ARROW, STYLE_SOLID);
   SetIndexArrow(0, 233);
   SetIndexArrow(1, 234);

   //--- バッファを空値で初期化
   SetIndexEmptyValue(0, 0.0);
   SetIndexEmptyValue(1, 0.0);

   //--- インジケータ名設定
   IndicatorShortName("karrows7_fixed (fish:" +
                      DoubleToStr(fish_threshold_up,2) + "/" +
                      DoubleToStr(fish_threshold_down,2) + " rsi:" +
                      DoubleToStr(rsi_threshold_up,2) + ")");

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| チャートから削除時の後処理                                        |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll();
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
   //--- 計算開始バーを決定
   int limit;
   if(prev_calculated == 0)
      limit = MathMin(rates_total - 2, maxlimit);
   else
      limit = rates_total - prev_calculated + 1;

   //================================================================
   // 【シグナル判定ロジック】
   // 修正案C: シンプル・実用的・バランス型
   //
   // UP信号:   fish01 > fish_threshold_up   && rsi_cur > rsi_threshold_up
   // DOWN信号: fish01 < fish_threshold_down && rsi_cur < rsi_threshold_down
   //
   // デフォルト値:
   //   fish_threshold_up    = 0.1   (fish値が明確に正）
   //   fish_threshold_down  = -0.1  (fish値が明確に負）
   //   rsi_threshold_up     = 0.5   (RSI > 0.5 = 買われすぎ寄り）
   //   rsi_threshold_down   = 0.5   (RSI < 0.5 = 売られすぎ寄り）
   //================================================================

   //--- DOWNシグナル計算ループ
   for(int i = limit; i >= 1; i--)
   {
      //--- KMACD（fish01）: バーi の値を取得
      double fish01 = iCustom(NULL, 0, "KMACD2",
                              period_KMACD,
                              0,   // バッファ0
                              i    // shift = バーi
                             );

      //--- LaguerreRSI: バーi の値（現在）
      double rsi_cur = iCustom(NULL, 0, "LaguerreRSI",
                               AAA, BBB, CCC,
                               DDD, EEE,
                               alertsOn, alertsOnCurrent, alertsMessage,
                               alertsSound, alertsNotify, alertsEmail, soundFile,
                               1,    // バッファ1
                               i     // shift = バーi
                              );

      //--- DOWNシグナル条件（修正案C）
      if(fish01 < fish_threshold_down
         && rsi_cur < rsi_threshold_down
        )
      {
         arrEntDown[i] = High[i]; // 矢印をバーiのHighに描画
      }
      else
      {
         arrEntDown[i] = 0.0; // シグナルなし
      }
   }

   //--- UPシグナル計算ループ
   for(int i = limit; i >= 1; i--)
   {
      //--- KMACD（fish01）: バーi の値を取得
      double fish01 = iCustom(NULL, 0, "KMACD2",
                              period_KMACD,
                              0,   // バッファ0
                              i    // shift = バーi
                             );

      //--- LaguerreRSI: バーi の値（現在）
      double rsi_cur = iCustom(NULL, 0, "LaguerreRSI",
                               AAA, BBB, CCC,
                               DDD, EEE,
                               alertsOn, alertsOnCurrent, alertsMessage,
                               alertsSound, alertsNotify, alertsEmail, soundFile,
                               1,    // バッファ1
                               i     // shift = バーi
                              );

      //--- UPシグナル条件（修正案C）
      if(fish01 > fish_threshold_up
         && rsi_cur > rsi_threshold_up
        )
      {
         arrEntUp[i] = Low[i]; // 矢印をバーiのLowに描画
      }
      else
      {
         arrEntUp[i] = 0.0; // シグナルなし
      }
   }

   //--- アラート処理（最新確定足）
   if(alertsOn_k6)
   {
      if(arrEntUp[1] != 0.0)   doAlert("UP");
      if(arrEntDown[1] != 0.0) doAlert("DOWN");
   }

   return(rates_total);
}

//+------------------------------------------------------------------+
//| アラート送信（同一バーで二重アラートを防ぐ制御付き）              |
//+------------------------------------------------------------------+
void doAlert(string doWhat)
{
   static string   previousAlert = "nothing";
   static datetime previousTime;
   string message;

   if(previousTime != Time[1] || previousAlert != doWhat)
   {
      previousTime  = Time[1];
      previousAlert = doWhat;

      message = StringConcatenate(Symbol(), " at ",
                                  TimeToStr(TimeLocal(), TIME_SECONDS),
                                  " ", indicator_name, " ", doWhat);

      if(alertsMessage_k6)  Alert(message);
      if(alertsNotify_k6)   SendNotification(message);
      if(alertsEmail_k6)    SendMail(StringConcatenate(Symbol(), " ", indicator_name), message);
      if(alertsSound_k6)    PlaySound(soundFile);
   }
}
//+------------------------------------------------------------------+
