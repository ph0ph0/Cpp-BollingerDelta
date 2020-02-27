//+------------------------------------------------------------------+
//|                                               BollingerDelta.mq4 |
//|                   Copyright 2020, LithoCode Ltd, Dr. Phillip Lee |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, LithoCode Ltd, Dr. Phillip Lee"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_separate_window

#property indicator_buffers 2

input int thresholdValue = 46;
input double multiplier = 2.4;
input int smaPeriod = 26;

double thresholdBuffer[];
double deltaBuffer[];

#define thresholdPosition 0
#define deltaPosition 1

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   SetIndexStyle(thresholdPosition, DRAW_LINE, STYLE_DOT, 1, clrGreen);
   SetIndexBuffer(thresholdPosition, thresholdBuffer);
   SetIndexLabel(thresholdPosition, "ThresholdLine");
   
   SetIndexStyle(deltaPosition, DRAW_LINE, STYLE_SOLID, 1, clrRed);
   SetIndexBuffer(deltaPosition, deltaBuffer);
   SetIndexLabel(deltaPosition, "BollingerBandDelta");
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
//---

   int limit;
   double sma, stdDev, upperBand, lowerBand, BB_Delta; 
   
   if (rates_total < smaPeriod)
      return(0);
   
   limit = rates_total - prev_calculated;
   if (prev_calculated > 0)
      limit++;
      
       

   for (int i=limit-1; i>=0; i--) { //left to right instead of right to left
   
      sma = iMA(Symbol(), Period(), smaPeriod, 0, MODE_SMA, PRICE_CLOSE, i);
      stdDev = iStdDev(Symbol(), Period(), smaPeriod, 0, MODE_SMA, PRICE_CLOSE, i);
      
      upperBand = sma + (stdDev * multiplier);
      lowerBand = sma - (stdDev * multiplier);
      BB_Delta = upperBand - lowerBand;
      
      deltaBuffer[i] = BB_Delta;
      thresholdBuffer[i] = thresholdValue;
      
      
   };

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+