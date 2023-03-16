unit Manip;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,USBCanDll, ExtCtrls, ComCtrls, Math;

  type TWMcan = TMessage;
  const WM_Can = $0401;

  type
    TForm1 = class(TForm)
    BtConnect: TButton;
    EdDevice: TEdit;
    BtDisconn: TButton;
    BtSendMode: TButton;
    BtSendPar: TButton;
    RdGrCtrl: TRadioGroup;
    TrBarAmp: TTrackBar;
    LbAmp: TLabel;
    LbVel: TLabel;
    TrBarVel: TTrackBar;
    RdGrDir: TRadioGroup;
    BtSendPos: TButton;
    onSM: TCheckBox;
    CommandText: TEdit;
    onSPar: TCheckBox;
    AmpText: TEdit;
    VelText: TEdit;
    chkLink1: TCheckBox;
    chkLink2: TCheckBox;
    chkLink3: TCheckBox;
    All: TCheckBox;
    res1: TEdit;
    res2: TEdit;
    res3: TEdit;
    ZeroPosition: TButton;
    m1: TEdit;
    m2: TEdit;
    m3: TEdit;
    q1: TEdit;
    q2: TEdit;
    q3: TEdit;
    tmr: TTimer;

    procedure BtConnectClick(Sender: TObject);
    procedure BtDisconnClick(Sender: TObject);
    procedure BtSendModeClick(Sender: TObject);
    procedure BtSendParClick(Sender: TObject);

    procedure BtSendPosClick(Sender: TObject);
    procedure onSMClick(Sender: TObject);
    procedure onSParClick(Sender: TObject);

    procedure TrBarAmpChange(Sender: TObject);
    procedure TrBarVelChange(Sender: TObject);
    procedure RdGrCtrlClick(Sender: TObject);

    procedure chkLink1Click(Sender: TObject);
    procedure chkLink2Click(Sender: TObject);
    procedure chkLink3Click(Sender: TObject);
    procedure AllClick(Sender: TObject);
    procedure RdGrDirClick(Sender: TObject);
   
    procedure ZeroPositionClick(Sender: TObject);
    procedure tmrTimer(Sender: TObject);





    ////
    
  protected
    procedure ProcessCanMes(var Message: TWMcan); message WM_Can;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
type
  pCanDataW=^tCanDataW;
  tCanDataW = array[1..4] of word;
  tArr = array [1..3] of integer;
  Angles = array[0..10, 0..2] of Integer;
var
     UsbHandle: tUcanHandle;
     pUsbHandle: pUcanHandle;
     HwInfo:tUcanHardwareInfo;
     CanMesRec,CanMesSend:tCanMsgStruct;
     baud,xx: word;
     pDataWR, pDataWS: pCanDataW;
     DataWR, DataWS: tCanDataW;
     FlPost,FlTr: boolean;
     DrN: byte;
     DrN1: byte = 0;
     DrN2: byte = 0;
     DrN3: byte = 0;
     Ang: Angles;
     //angle: tArr;

     flag: Integer = -1;

procedure UcanCallbackFkt(UcanHandle_p:tUcanHandle; bEvent_p:byte); stdcall;
 //var i:byte;
begin
    if bEvent_p=USBCAN_EVENT_RECIEVE then begin
        UcanReadCanMsg (UsbHandle, @CanMesRec);
 //       if (CanMesRec.m_dwID=1) then begin
          DataWR:=pDataWR^;
         // Form1.EdDevice.Text:=IntToStr(DataWR[2]);
          //    !!!!!!!!!!!!!!
          //Form1.EdDevice.Refresh;
          if DrN1 =1 then begin
          Form1.res1.Text:=  IntToStr(DataWR[2]);
          Form1.res1.Refresh;
          end;
          if DrN2 =2 then begin
          Form1.res2.Text:=  IntToStr(DataWR[2]);
          Form1.res1.Refresh;
          end;
          if DrN3 =3 then begin
          Form1.res3.Text:=  IntToStr(DataWR[2]);
          Form1.res1.Refresh;
          end;

    end;

end;

procedure TForm1.ProcessCanMes(var Message: TWMcan);
//var k:word;
begin
   FlPost:=true;
end;


procedure TForm1.BtConnectClick(Sender: TObject);
  var bBTR0_p, bBTR1_p,res:byte;
begin
   bBTR0_p:=$00;
   bBTR1_p:=$2B; //$58;
   pUsbHandle := @UsbHandle;
   res:=UcanInitHardware(pUsbHandle,USBCAN_ANY_MODULE, UcanCallbackFkt);
   res:=UcanGetHardwareInfo(UsbHandle, @HwInfo);
   EdDevice.Text:=IntToStr(HwInfo.m_dwSerialNr)+' N '+IntToStr(HwInfo.m_bDeviceNr);
   EdDevice.Refresh;
   res:=UcanInitCan (UsbHandle, bBTR0_p, bBTR1_p, USBCAN_AMR_ALL,USBCAN_ACR_ALL );
   pDataWR:=@CanMesRec.m_bData;  pDataWS:=@CanMesSend.m_bData;
   with CanMesSend do begin
     m_dwID:=2;     // CAN message Identifier
     m_bFF:=0;      // CAN Frame format (BIT7=1: 29BitID / BIT6=1: RTR-Frame)
     m_bDLC:=8;     // CAN Data Length Code
     m_bData[1]:=1;  m_bData[2]:=2; m_bData[3]:=3; m_bData[4]:=4; //
     m_bData[5]:=5;  m_bData[6]:=6; m_bData[7]:=7;  m_bData[8]:=8; //
   end; // m_dwTime:longword;   // Time in ms

    FlPost:=true;  FlTr:=false;


end;



procedure TForm1.BtDisconnClick(Sender: TObject);
var res:byte;
begin
  UcanResetCan (UsbHandle);
  res:=UcanDeinitCan(UsbHandle);
  res:= UcanDeinitHardware(UsbHandle);
  EdDevice.Text:=IntToStr(res);
  EdDevice.Refresh;
end;
/////
/////---------------------------------------------------------------------------
//with buttons
procedure TForm1.BtSendModeClick(Sender: TObject);
 var k:byte;
begin
      if onSM.Checked  then   begin
       k:=RdGrCtrl.ItemIndex;
       CanMesSend.m_bData[1]:= k;
      // if k>0 then CanMesSend.m_bData[2]:=1
      //  else CanMesSend.m_bData[2]:=0;
      // CanMesSend.m_dwID:=DrN shl 4;
      // UcanWriteCanMsg (UsbHandle, @CanMesSend);
       CommandText.Text :=RdGrCtrl.Items[RdGrCtrl.ItemIndex];
       CommandText.Refresh;

       if k>0 then CanMesSend.m_bData[2]:=0 //1
        else CanMesSend.m_bData[2]:=0;

       if DrN1 =1 then begin
       CanMesSend.m_dwID:=DrN1 shl 4;
       UcanWriteCanMsg (UsbHandle, @CanMesSend);
      // l1.Text:='SM 1'  ;
       end;
       if DrN2 =2 then begin
       CanMesSend.m_dwID:=DrN2 shl 4;
       UcanWriteCanMsg (UsbHandle, @CanMesSend);
       //l2.Text:='SM 2';
       end;
       if DrN3 =3 then begin
       CanMesSend.m_dwID:=DrN3 shl 4;
       UcanWriteCanMsg (UsbHandle, @CanMesSend);
       //l3.Text:='SM 3'  ;
       end;

       end;
end;

procedure TForm1.BtSendParClick(Sender: TObject);
begin
  if onSPar.Checked then begin
     CanMesSend.m_bData[1]:=TrBarAmp.Position;
     CanMesSend.m_bData[2]:=21-TrBarVel.Position;
     CanMesSend.m_bData[3]:=RdGrDir.ItemIndex;
     //CanMesSend.m_dwID:=DrN shl 4+2;
     //UcanWriteCanMsg (UsbHandle, @CanMesSend);

                if DrN1 =1 then begin
            CanMesSend.m_dwID:=DrN1 shl 4+2;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
            //l1.Text:='par 1' ;
            end;
             if DrN2 =2 then begin
            CanMesSend.m_dwID:=DrN2 shl 4+2;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
           // l2.Text:='par 2';
            end;
            if DrN3 =3 then begin
            CanMesSend.m_dwID:=DrN3 shl 4+2;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
           // l3.Text:='par 3' ;
            end;

   //AmpText.Text:=IntToStr(TrBarAmp.Position)   ;
   //AmpText.Refresh;
   end;
end;
//----------------------------------------------------------------------
procedure TForm1.BtSendPosClick(Sender: TObject);
var X,Y,Z,X_flag, theta_1, theta_2, theta_3, X_21, Z_21, l_35,alfa, gama, mu, lamda, th_1, th_2, th_3: Extended;
l_34, l_45 , l_23, a, b, X1,Y1, Z1, X2, Y2, Z2, i: Integer;

begin
  a:=50;
  b:=160;
  l_34:=60;
  l_45:=320;
  l_23:=220;

    // CanMesSend.m_bData[1]:=TrBarPos.Position;
     //CanMesSend.m_bData[2]:=0;
    // CanMesSend.m_bData[3]:=0;
     //CanMesSend.m_dwID:=DrN shl 4+1;
     X1:=StrToInt(m1.Text);
     Y1:=StrToInt(m2.Text);
     Z1:=StrToInt(m3.Text);
     X2:=StrToInt(q1.Text);
     Y2:=StrToInt(q2.Text);
     Z2:=StrToInt(q3.Text);
    for i:=0 to 10 do
    begin

      X:=X1+i*(X2-X1)/10;
      Y:=Y1+i*(Y2-Y1)/10;
      Z:=Z1+i*(Z2-Z1)/10;

      if X=0 then theta_1:=DegToRad(90)
      else begin
      X_flag :=X;
      X:= Abs(X);
      theta_1:= ArcTan(Y/X);
      end;

      X_21 := X*Cos(theta_1)+Y*Sin(theta_1)-a ;
      Z_21:= Z-b;
      l_35 := Sqrt((l_34)*(l_34)+ (l_45)*(l_45));
      alfa := ArcTan((l_45)/(l_34));
      gama := ArcCos(((l_23)*(l_23)+(l_35)*(l_35)-(X_21)*(X_21)-(Z_21)*(Z_21))/(2*(l_23)*(l_35)));
      mu:= ArcTan((Z_21)/(X_21));
      lamda:= ArcCos(((l_23)*(l_23)-(l_35)*(l_35)+(X_21)*(X_21)+(Z_21)*(Z_21))/(2*(l_23)*Sqrt((X_21)*(X_21)+(Z_21)*(Z_21))));
      theta_2:= Pi/2 - mu-lamda;
      theta_3:=Pi-alfa-gama+theta_2-DegToRad(22);

      if (X_flag<0) and (Y<0) then theta_1:=-theta_1+Pi
      else if (X_flag<0) and (Y>0) then theta_1:=theta_1-Pi
      else if (X_flag>0) and (Y<0) then theta_1:=Abs(theta_1)
      else if (X_flag>0) and (Y>0) then theta_1:=-theta_1;

      th_1:=RadToDeg(theta_1);
      th_2:=RadToDeg(theta_2);
      th_3:=RadToDeg(-theta_3);

      Ang[i,0]:=Round(th_1);
      Ang[i,1]:=Round(th_2);
      Ang[i,2]:=Round(th_3);
      flag:=0;
      tmr.Enabled:=True;

     //UcanWriteCanMsg (UsbHandle, @CanMesSend);
     end;

end;

//////
//////  ------------------------------------------------------------------------
//on/off buttons
procedure TForm1.onSMClick(Sender: TObject);
begin
        if onSM.Checked then
            begin       //процедура нажатия кнопки
              BtSendMode.Enabled := onSM.Checked ;
              CommandText.Text:='SendMode on';
              CommandText.Refresh  ;
            end else
            begin
              BtSendMode.Enabled := onSM.Checked;
              CommandText.Text:='SendMode off';
              CommandText.Refresh;
            end;
end;
   ////
procedure TForm1.onSParClick(Sender: TObject);
begin
       if onSPar.Checked then
            begin       //процедура нажатия кнопки
              BtSendPar.Enabled := onSPar.Checked ;
              CommandText.Text:='SendPar on';
              CommandText.Refresh  ;
            end else
            begin
              BtSendPar.Enabled := onSPar.Checked;
              CommandText.Text:='SendPar off';
              CommandText.Refresh;
            end;
end;
                   ////

////
//// --------------------------------------------------------------------------
//withot buttons
procedure TForm1.TrBarAmpChange(Sender: TObject);
begin
    AmpText.Text := IntToStr( TrBarAmp.Position);
    if not onSPar.Checked  then   begin


     //CanMesSend.m_bData[1]:=TrBarAmp.Position;
     CanMesSend.m_bData[3]:=RdGrDir.ItemIndex;
      if DrN1 =1 then begin
      CanMesSend.m_bData[1]:=2*TrBarAmp.Position;
     CanMesSend.m_dwID:=DrN1 shl 4+2;
     UcanWriteCanMsg (UsbHandle, @CanMesSend);
     //l1.Text:='wb Amp 1';
     end;
      if DrN2 =2 then begin
     CanMesSend.m_bData[1]:=TrBarAmp.Position;
     CanMesSend.m_dwID:=DrN2 shl 4+2;
     UcanWriteCanMsg (UsbHandle, @CanMesSend);
    // l2.Text:='wb Amp 2';
     end;
     if DrN3 =3 then begin
     CanMesSend.m_bData[1]:=TrBarAmp.Position;
     CanMesSend.m_dwID:=DrN3 shl 4+2;
     UcanWriteCanMsg (UsbHandle, @CanMesSend);
    // l3.Text:='wb Amp 3';
     end;
     //VelText.Text:='qqq';
     end;
end;
       ////

procedure TForm1.TrBarVelChange(Sender: TObject);
begin
           VelText.Text := IntToStr( TrBarVel.Position);
           if not onSPar.Checked then begin
            CanMesSend.m_bData[2]:=21-TrBarVel.Position;
           // CanMesSend.m_bData[3]:=RdGrDir.ItemIndex;

            if DrN1 =1 then begin
            CanMesSend.m_dwID:=DrN1 shl 4+2;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
            //l1.Text:='wb vel 1';
            end;
             if DrN2 =2 then begin
            CanMesSend.m_dwID:=DrN2 shl 4+2;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
            //l2.Text:='wb vel 2';
            end;
            if DrN3 =3 then begin
            CanMesSend.m_dwID:=DrN3 shl 4+2;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
            //l3.Text:='wb vel 3';
            end;
           //AmpText.Text:='www';
           end;
end;


procedure TForm1.RdGrDirClick(Sender: TObject);
begin
        if not onSPar.Checked then begin
            CanMesSend.m_bData[3]:=RdGrDir.ItemIndex;

            if DrN1 =1 then begin
            CanMesSend.m_dwID:=DrN1 shl 4+2;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
           // l1.Text:='wb dir 1';
            end;
             if DrN2 =2 then begin
            CanMesSend.m_dwID:=DrN2 shl 4+2;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
           // l2.Text:='wb dir 2';
            end;
            if DrN3 =3 then begin
            CanMesSend.m_dwID:=DrN3 shl 4+2;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
           // l3.Text:='wb dir 3';
            end;
           //AmpText.Text:='www';
           end;
end;


procedure TForm1.RdGrCtrlClick(Sender: TObject);
var k:byte;
begin
   if not onSM.Checked  then   begin
   CommandText.Text :=RdGrCtrl.Items[RdGrCtrl.ItemIndex];
   CommandText.Refresh;
   

       k:=RdGrCtrl.ItemIndex;
       CanMesSend.m_bData[1]:= k;

       if k>0 then CanMesSend.m_bData[2]:=0 //1
        else CanMesSend.m_bData[2]:=0;

       if DrN1 =1 then begin
       CanMesSend.m_dwID:=DrN1 shl 4;
       UcanWriteCanMsg (UsbHandle, @CanMesSend);
       //l1.Text:='wb sm 1'
       end;
       if DrN2 =2 then begin
       CanMesSend.m_dwID:=DrN2 shl 4;
       UcanWriteCanMsg (UsbHandle, @CanMesSend);
     //  l2.Text:='wb sm 2'
       end;
       if DrN3 =3 then begin
       CanMesSend.m_dwID:=DrN3 shl 4;
       UcanWriteCanMsg (UsbHandle, @CanMesSend);
     //  l3.Text:='wb sm 3'
       end;

       //CommandText.Text :=RdGrCtrl.Items[RdGrCtrl.ItemIndex];
       //CommandText.Refresh;
   //AmpText.Text:='eee';
   end;
end;


//////////
//////////
//about joint's number  1-3 -==-------------------------------------------------

procedure TForm1.chkLink1Click(Sender: TObject);
begin
         if  chkLink1.Checked then  begin
         DrN1:=1;
         CommandText.Text :='DrN1';
         end;
          if   chkLink1.Checked = false then
          begin
           DrN1:=0;
           CommandText.Text :='not DrN1';
           All.Checked := False;
           end;

end;

procedure TForm1.chkLink2Click(Sender: TObject);
begin
          if   chkLink2.Checked then
          begin
           DrN2:=2;
           CommandText.Text :='DrN2';
          end;
           if   chkLink2.Checked = false then
          begin
           DrN2:=0;
           CommandText.Text :='not DrN2';
            All.Checked := False;
           end;
end;

procedure TForm1.chkLink3Click(Sender: TObject);
begin
        if   chkLink3.Checked then
          begin
           DrN3:=3;
           CommandText.Text :='DrN3';
          end;
          if   chkLink3.Checked = false then
          begin
           DrN3:=0;
           CommandText.Text :='not DrN3';
            All.Checked := False;
          end;
end;

procedure TForm1.AllClick(Sender: TObject);
begin
if All.Checked then begin
  chkLink1.Checked := True;
  chkLink2.Checked := True;
  chkLink3.Checked := True;
  CommandText.Text :='All';
  end;

end;

///////
///////  -----------------------------------------------------------------------


//   как передать конкретный датчик в вывод?


procedure TForm1.ZeroPositionClick(Sender: TObject);
begin
           CanMesSend.m_bData[2]:=0;
            CanMesSend.m_bData[3]:=0;



            if chkLink1.Checked = True then begin
            //  trckbr_1.Position:=64;
            CanMesSend.m_bData[1]:= 64;

            CanMesSend.m_dwID:=DrN1 shl 4+1;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
             res1.Text:='0';
            end;

            if chkLink2.Checked then begin
             //trckbr_2.Position:=64;
            CanMesSend.m_dwID:=DrN2 shl 4+1;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
            res2.Text:='0';
              end;
            if chkLink3.Checked then begin
            // trckbr_3.Position:=64;
            CanMesSend.m_dwID:=DrN3 shl 4+1;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
            res3.Text:='0';
              end;
     //UcanWriteCanMsg (UsbHandle, @CanMesSend);

end;





procedure TForm1.tmrTimer(Sender: TObject);
begin

    if (flag>-1) and (flag<21) then begin

     if DrN1 =1 then begin

            res1.Text := IntToStr( Ang[0,0]);
           CanMesSend.m_bData[1]:=3*(Ang[0,0]) +64 ;
            //CanMesSend.m_bData[1]:=trckbr_1.Position;
             CanMesSend.m_bData[2]:=0;
     CanMesSend.m_bData[3]:=0;
            CanMesSend.m_dwID:=DrN1 shl 4+1;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
           // l1.Text:='pos 111111';

            end;
     if DrN2 =2 then begin
            res2.Text := IntToStr(Ang[0,1]);
            //CanMesSend.m_bData[1]:=trckbr_2.Position;
            CanMesSend.m_bData[1]:=3*Ang[0,1] +64 ;
            CanMesSend.m_bData[2]:=0;
     CanMesSend.m_bData[3]:=0;
            CanMesSend.m_dwID:=DrN2 shl 4+1;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
            //l2.Text:='pos 222222';
            end;
     if DrN3 =3 then begin
           res3.Text := IntToStr(Ang[0,2]);
            //CanMesSend.m_bData[1]:=trckbr_3.Position;
            CanMesSend.m_bData[1]:=3*Ang[0,2] +64 ;
            CanMesSend.m_bData[2]:=0;
     CanMesSend.m_bData[3]:=0;
            CanMesSend.m_dwID:=DrN3 shl 4+1;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
           // l3.Text:='pos 333333';
            end;
     flag:=flag+1;
     end;

     if (flag>20) and (flag<31) then begin

     if DrN1 =1 then begin

            res1.Text := IntToStr( Ang[flag-20,0]);
           CanMesSend.m_bData[1]:=3*(Ang[flag-20,0]) +64 ;
            //CanMesSend.m_bData[1]:=trckbr_1.Position;
             CanMesSend.m_bData[2]:=0;
     CanMesSend.m_bData[3]:=0;
            CanMesSend.m_dwID:=DrN1 shl 4+1;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
           // l1.Text:='pos 111111';

            end;
     if DrN2 =2 then begin
            res2.Text := IntToStr(Ang[flag-20,1]);
            //CanMesSend.m_bData[1]:=trckbr_2.Position;
            CanMesSend.m_bData[1]:=3*Ang[flag-20,1] +64 ;
            CanMesSend.m_bData[2]:=0;
     CanMesSend.m_bData[3]:=0;
            CanMesSend.m_dwID:=DrN2 shl 4+1;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
           // l2.Text:='pos 222222';
            end;
     if DrN3 =3 then begin
           res3.Text := IntToStr(Ang[flag-20,2]);
            //CanMesSend.m_bData[1]:=trckbr_3.Position;
            CanMesSend.m_bData[1]:=3*Ang[flag-20,2] +64 ;
            CanMesSend.m_bData[2]:=0;
     CanMesSend.m_bData[3]:=0;
            CanMesSend.m_dwID:=DrN3 shl 4+1;
            UcanWriteCanMsg (UsbHandle, @CanMesSend);
           // l3.Text:='pos 333333';
            end;
     flag:=flag+1;
     end;
    if flag=31 then tmr.Enabled:=False;

end;


end.
