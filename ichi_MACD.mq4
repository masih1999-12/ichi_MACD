//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Moving Averages Convergence/Divergence"
#property strict


//--- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1  Black
#property  indicator_width1  4
//--- indicator parameters

//--- indicator buffers
double    ExtMacdBuffer[];

//setting for indicator
// 1 means te-ke (9-26)
// 2 means te-sb (9-52)
// 3 means te-(te-ke) 9-(9-26)
int setting = 1;


//default value for stting 1 
//value for stting 2 = 9 52
int part1=9,part2=26;

//botton names
string botton_te_ke="te-ke";
string botton_te_sb="te-sb";
string botton_te_te_ke="te-(te-ke)";

//botton texts
string botton_text_te_ke="TE - KE";
string botton_text_te_sb="TE - SB";
string botton_text_te_te_ke="TE - (TE - KE)";


int subwindow_number=1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   
   EventSetTimer(1);
   IndicatorDigits(Digits+1);
//--- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   
   
//choose smalest input
   
   SetIndexDrawBegin(1,9);
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtMacdBuffer);
//--- name for DataWindow and indicator subwindow label
   IndicatorShortName("ICHI_MACD("+IndicatorName()+")");
   SetIndexLabel(0,"ICHI_MACD");
//--- check for input parameters
//--- initialization done
   Setting();
   Buttons();
   //Start();
   return(INIT_SUCCEEDED);
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
//   ArraySetAsSeries(open,false);
//   ArraySetAsSeries(high,false);
//   ArraySetAsSeries(low,false);
//   ArraySetAsSeries(close,false);
//   int limit;
////---
//   if(rates_total<=9 )
//      return(0);
////--- last counted bar will be recounted
//   limit=rates_total-prev_calculated;
//   if(prev_calculated>0)
//      limit++;
////--- macd counted in the 1-st buffer
//   double mid1=0,mid2=0;
//   for(int j=0; j<limit; j++)
//   {
//      //highest part1
//      double h=iHigh(_Symbol,_Period,j);
//      for (int i=j+1;i<j+part1;i++)
//      {
//         if(iHigh(_Symbol,_Period,i)>h)
//            h= iHigh(_Symbol,_Period,i);
//      }
//      
//      //lowest part1
//      double l=iLow(_Symbol,_Period,j);
//      for (int i=j+1;i<j+part1;i++)
//      {
//         if(iLow(_Symbol,_Period,i)<l)
//            l= iLow(_Symbol,_Period,i);
//      }
//      mid1=NormalizeDouble((h+l),_Digits);
//      
//      //highest part2
//      h=iHigh(_Symbol,_Period,j);
//      for (int i=j+1;i<j+part2;i++)
//      {
//         if(iHigh(_Symbol,_Period,i)>h)
//            h= iHigh(_Symbol,_Period,i);
//      }
//      
//      //lowest part2
//      l=iLow(_Symbol,_Period,j);
//      for (int i=j+1;i<j+part2;i++)
//      {
//         if(iLow(_Symbol,_Period,i)<l)
//            l= iLow(_Symbol,_Period,i);
//      }
//      mid2=NormalizeDouble((h+l),_Digits);
//      
//      ExtMacdBuffer[j]=mid1-mid2;
//   
//   }
   return(rates_total);
  }
//+------------------------------------------------------------------+

void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
    if (id == CHARTEVENT_OBJECT_CLICK) {
            ObjectSetInteger(0, botton_te_ke, OBJPROP_STATE, false);
            ObjectSetInteger(0, botton_te_sb, OBJPROP_STATE, false);
            ObjectSetInteger(0, botton_te_te_ke, OBJPROP_STATE, false);
       if(sparam==botton_te_ke)
           {
               Sleep(100);            
               setting=1;
           }
       if(sparam==botton_te_sb)        
            {
               Sleep(100);
               setting=2;
           }
       if(sparam==botton_te_te_ke)        
            {
               Sleep(100);
               setting=3;
           }  
       Setting();   
       Start();   
      }            
}  

//+------------------------------------------------------------------+
//| Create the button                                                |
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               x=0,                      // X coordinate
                  const int               y=0,                      // Y coordinate
                  const int               width=50,                 // button width
                  const int               height=18,                // button height
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                  const string            text="Button",            // text
                  const string            font="Arial",             // font
                  const int               font_size=10,             // font size
                  const color             clr=clrBlack,             // text color
                  const color             back_clr=C'236,233,216',  // background color
                  const color             border_clr=clrNONE,       // border color
                  const bool              state=false,              // pressed/released
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden=true,              // hidden in the object list
                  const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create the button
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create the button! Error code = ",GetLastError());
      return(false);
     }
//--- set button coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set button size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
//--- enable (true) or disable (false) the mode of moving the button by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
void Setting(){
   if(setting==1){
          part1=9;
          part2=26;
   }
   
   if(setting==2){
          part1=9;
          part2=52;
   }
   
   if(setting==3){
        part1=9;
        part2=26;
   }
}
string IndicatorName()
{
   
   string r;
   if (setting==1)
      r=botton_text_te_ke;
   else if (setting==2)
      r=botton_text_te_sb;
   else if (setting==3)
      r=botton_text_te_te_ke;
   return r;
}
void Buttons(){
//--- create the button
ButtonCreate(0,botton_te_ke,subwindow_number,5,20,70,20,CORNER_LEFT_UPPER,botton_text_te_ke,"Arial",8,
      clrBlack,C'236,233,216',clrNONE,false,false,false,true,0);

ButtonCreate(0,botton_te_sb,subwindow_number,5,50,70,20,CORNER_LEFT_UPPER,botton_text_te_sb,"Arial",8,
      clrBlack,C'236,233,216',clrNONE,false,false,false,true,0);

ButtonCreate(0,botton_te_te_ke,subwindow_number,5,80,70,20,CORNER_LEFT_UPPER,botton_text_te_te_ke,"Arial",8,
      clrBlack,C'236,233,216',clrNONE,false,false,false,true,0); 
}

//+------------------------------------------------------------------+
//|      START                                                      |
//+------------------------------------------------------------------+
void Start()
{
      
     if (setting==1 || setting ==2)
     for (int i=Bars-53;i>=0;i--)
         {
            ExtMacdBuffer[i]=FindMid(i,part1)-FindMid(i,part2);
         }
     else if (setting==3)
     {
         for (int i=Bars-53;i>=0;i--)
         {
            ExtMacdBuffer[i]=FindMid(i,part1)-(FindMid(i,part1)-FindMid(i,part2));
         }   
     }
     
}
double FindMid(int s , int count)
{
   return NormalizeDouble((FindHigh(s,count)+FindLow(s,count))/2,_Digits);
}
double FindHigh(int s , int count)
{
      double h=iHigh(_Symbol,_Period,s);
      for (int i=s+1;i<s+count;i++)
      {
         if(iHigh(_Symbol,_Period,i)>h)
            h= iHigh(_Symbol,_Period,i);
      }
      return NormalizeDouble(h,_Digits);
}
double FindLow(int s , int count)
{
      double l=iLow(_Symbol,_Period,s);
      for (int i=s+1;i<s+count;i++)
      {
         if(iLow(_Symbol,_Period,i)<l)
            l= iLow(_Symbol,_Period,i);
      }
      return NormalizeDouble(l,_Digits);
      }