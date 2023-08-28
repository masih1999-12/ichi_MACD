//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Moving Averages Convergence/Divergence"
#property strict

#include <MovingAverages.mqh>

//--- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  Silver
#property  indicator_color2  Red
#property  indicator_width1  2
//--- indicator parameters
input int InpFastEMA=12;   // Fast EMA Period
input int InpSlowEMA=26;   // Slow EMA Period
input int InpSignalSMA=9;  // Signal SMA Period
//--- indicator buffers
double    ExtMacdBuffer[];
double    ExtSignalBuffer[];
//--- right input parameters flag
bool      ExtParameters=false;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   EventSetTimer(1);
   IndicatorDigits(Digits+1);
//--- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexDrawBegin(1,InpSignalSMA);
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtMacdBuffer);
   SetIndexBuffer(1,ExtSignalBuffer);
//--- name for DataWindow and indicator subwindow label
   IndicatorShortName("MACD("+IntegerToString(InpFastEMA)+","+IntegerToString(InpSlowEMA)+","+IntegerToString(InpSignalSMA)+")");
   SetIndexLabel(0,"MACD");
   SetIndexLabel(1,"Signal");
//--- check for input parameters
   if(InpFastEMA<=1 || InpSlowEMA<=1 || InpSignalSMA<=1 || InpFastEMA>=InpSlowEMA)
     {
      Print("Wrong input parameters");
      ExtParameters=false;
      return(INIT_FAILED);
     }
   else
      ExtParameters=true;
//--- initialization done
   return(INIT_SUCCEEDED);
  }
  
void OnTimer()
{
   
}
  
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int OnCalculate (const int rates_total,
                 const int prev_calculated,
                 const datetime& time[],
                 const double& open[],
                 const double& high[],
                 const double& low[],
                 const double& close[],
                 const long& tick_volume[],
                 const long& volume[],
                 const int& spread[])
  {
   ArraySetAsSeries(open,false);
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);
   int limit;
//---
   if(rates_total<=InpSignalSMA || !ExtParameters)
      return(0);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;
   if(prev_calculated>0)
      limit++;
//--- macd counted in the 1-st buffer
   double mid9=0,mid26=0;
   for(int j=0; j<limit; j++)
   {
      //highest 9
      double h=iHigh(_Symbol,_Period,j);
      for (int i=j+1;i<j+9;i++)
      {
         if(iHigh(_Symbol,_Period,i)>h)
            h= iHigh(_Symbol,_Period,i);
      }
      
      //lowest 9
      double l=iLow(_Symbol,_Period,j);
      for (int i=j+1;i<j+9;i++)
      {
         if(iLow(_Symbol,_Period,i)<l)
            l= iLow(_Symbol,_Period,i);
      }
      mid9=NormalizeDouble((h+l),_Digits);
      
      //highest 26
      h=iHigh(_Symbol,_Period,j);
      for (int i=j+1;i<j+26;i++)
      {
         if(iHigh(_Symbol,_Period,i)>h)
            h= iHigh(_Symbol,_Period,i);
      }
      
      //lowest 9
      l=iLow(_Symbol,_Period,j);
      for (int i=j+1;i<j+26;i++)
      {
         if(iLow(_Symbol,_Period,i)<l)
            l= iLow(_Symbol,_Period,i);
      }
      mid26=NormalizeDouble((h+l),_Digits);
      
      ExtMacdBuffer[j]=mid9-mid26;
   
   }
//--- signal line counted in the 2-nd buffer
   //SimpleMAOnBuffer(rates_total,prev_calculated,0,InpSignalSMA,ExtMacdBuffer,ExtSignalBuffer);
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
double mid_rectangle(int count , int s){
   double r;
   count--;
   double h,l;
   
   h=Highest(count , s);
   l=Lowest(count , s);
   r = h-l;
   return r;
}

double Highest(int c,int s)
{
   double r=iHigh(_Symbol,_Period,s);
   for (int i=s+1;i<s+c;i++)
   {
      if(iHigh(_Symbol,_Period,i)>r)
         r= iHigh(_Symbol,_Period,i);
   }
   return r;
}

double Lowest(int count,int s)
{
   double r=iLow(_Symbol,_Period,s);
   for (int i=s+1;i<s+count;i++)
   {
      if(iLow(_Symbol,_Period,i)<r)
         r= iLow(_Symbol,_Period,i);
   }
   return r;
}