package
{
   import Shared.*;
   import Shared.AS3.*;
   import Shared.AS3.Data.*;
   import Shared.AS3.Events.*;
   import com.adobe.serialization.json.*;
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import scaleform.gfx.*;
   
   public class AreaLootButtonFix extends MovieClip
   {
      
      public static const MOD_NAME:String = "AreaLootButtonFix";
      
      public static const MOD_VERSION:String = "1.0.0";
      
      public static const FULL_MOD_NAME:String = MOD_NAME + " " + MOD_VERSION;
      
      private static const DEBUG:Boolean = false;
      
      private static const TITLE_HUDMENU:String = "HUDMenu";
      
      private var topLevel:* = null;
      
      private var FrobberData:* = null;
      
      private var QuickContainerWidget_mc:* = null;
      
      private var timer:Timer;
      
      public function AreaLootButtonFix()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler,false,0,true);
      }
      
      public static function toString(param1:Object) : String
      {
         return new JSONEncoder(param1).getString();
      }
      
      public static function ShowHUDMessage(param1:String) : void
      {
         GlobalFunc.ShowHUDMessage("[" + FULL_MOD_NAME + "] " + param1);
      }
      
      public function addedToStageHandler(param1:Event) : *
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler,false,0,true);
         this.topLevel = stage.getChildAt(0);
         if(Boolean(this.topLevel))
         {
            if(getQualifiedClassName(this.topLevel) == TITLE_HUDMENU)
            {
               this.init();
            }
         }
      }
      
      public function removedFromStageHandler(param1:Event) : *
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.showButtons);
         }
         if(this.FrobberData)
         {
            this.FrobberData.removeEventListener(Event.CHANGE,this.frobberDataUpdate);
         }
      }
      
      public function init() : void
      {
         this.getQuickContainerWidget();
         this.initButtonTimer();
         this.initFrobberUpdates();
      }
      
      public function getQuickContainerWidget() : void
      {
         if(this.topLevel && this.topLevel.CenterGroup_mc && this.topLevel.CenterGroup_mc.QuickContainerWidget_mc)
         {
            this.QuickContainerWidget_mc = this.topLevel.CenterGroup_mc.QuickContainerWidget_mc;
            setTimeout(ShowHUDMessage,30000,"Init OK!");
         }
         else
         {
            setTimeout(ShowHUDMessage,30000,"Error initializing: QuickContainerWidget not found!");
         }
      }
      
      public function initButtonTimer() : void
      {
         this.timer = new Timer(50);
         this.timer.addEventListener(TimerEvent.TIMER,this.showButtons,false,0,true);
         this.timer.start();
      }
      
      public function initFrobberUpdates() : void
      {
         this.FrobberData = BSUIDataManager.GetDataFromClient("FrobberData");
         this.FrobberData.addEventListener(Event.CHANGE,this.frobberDataUpdate,false,int.MAX_VALUE);
      }
      
      public function showButtons() : void
      {
         try
         {
            if(!this.QuickContainerWidget_mc)
            {
               return;
            }
            if(this.QuickContainerWidget_mc.AButton.ButtonVisible)
            {
               this.QuickContainerWidget_mc.AButton.ButtonEnabled = true;
            }
            if(this.QuickContainerWidget_mc.XButton.ButtonVisible)
            {
               this.QuickContainerWidget_mc.XButton.ButtonEnabled = true;
            }
            if(this.QuickContainerWidget_mc.YButton.ButtonVisible)
            {
               this.QuickContainerWidget_mc.YButton.ButtonEnabled = true;
            }
            if(DEBUG)
            {
               ShowHUDMessage("buttons set");
            }
         }
         catch(e:*)
         {
            ShowHUDMessage("showButtons error: " + e);
         }
      }
      
      public function frobberDataUpdate(param1:FromClientDataEvent) : void
      {
         var i:int = 0;
         try
         {
            while(i < param1.data.buttons.length)
            {
               param1.data.buttons[i].enabled = true;
               i++;
            }
            if(DEBUG)
            {
               ShowHUDMessage("FrobberDataUpdate");
            }
         }
         catch(e:*)
         {
            ShowHUDMessage("FrobberDataUpdate error: " + e);
         }
      }
   }
}

