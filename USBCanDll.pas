unit USBCanDll;

interface
 uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

 const USBCANLib:string ='USBCAN32.dll';
 // maximum number of modules, that are supported (can not be changed!)  
 USBCAN_MAX_MODULES=10;
// maximum number of applications, that can make use of this DLL (can not be changed!)
 USBCAN_MAX_INSTANCES=10;

// With the function UcanInitHardware() the module is used, which is detected first.
// This define should only be used, in case only one module is connected to the computer.
 USBCAN_ANY_MODULE=255;

// no valid USB-CAN Handle
 USBCAN_INVALID_HANDLE=$ff;

// pre-defined baudrate values
 USBCAN_BAUD_10kBit  = $672f;              // 10 kBit/s
 USBCAN_BAUD_20kBit  = $532f;              // 20 kBit/s
 USBCAN_BAUD_50kBit  = $472f;              // 50 kBit/s
 USBCAN_BAUD_100kBit = $432f;              // 100 kBit/s
 USBCAN_BAUD_125kBit = $031c;              // 125 kBit/s
 USBCAN_BAUD_250kBit = $011c;              // 250 kBit/s
 USBCAN_BAUD_500kBit = $001c;              // 500 kBit/s
 USBCAN_BAUD_800kBit = $0016;              // 800 kBit/s
 USBCAN_BAUD_1MBit   = $0014;              // 1 MBit/s

// Frame format for a CAN message
 USBCAN_MSG_FF_RTR   = $40;         // Remote Transmition Request Frame
 USBCAN_MSG_FF_EXT   = $80;         // Extended Format (29-Bit-ID)

// Function return codes (encoding)
 USBCAN_SUCCESSFUL   = $00;         // no error
 USBCAN_ERR          = $01;         // error in DLL; function has not been executed
 USBCAN_ERRCMD       = $40;         // error in module; function has not been executed
 USBCAN_WARNING      = $80;         // Warning; function has been executed anyway
 USBCAN_RESERVED     = $c0;         // reserved return codes (up to 255)

// Error messages, that can occur in the DLL
 USBCAN_ERR_RESOURCE    = $01;      // could not created a resource (memory, Handle, ...)
 USBCAN_ERR_MAXMODULES  = $02;      // the maximum number of open modules is exceeded
 USBCAN_ERR_HWINUSE     = $03;      // a module is already in use
 USBCAN_ERR_ILLVERSION  = $04;      // the software versions of the module and DLL are incompatible
 USBCAN_ERR_ILLHW       = $05;      // the module with the corresponding device number is not connected
 USBCAN_ERR_ILLHANDLE   = $06;      // wrong USB-CAN-Handle handed over to the function
 USBCAN_ERR_ILLPARAM    = $07;      // wrong parameter handed over to the function
 USBCAN_ERR_BUSY        = $08;      // instruction can not be processed at this time
 USBCAN_ERR_TIMEOUT     = $09;      // no answer from the module
 USBCAN_ERR_IOFAILED    = $0a;      // a request for the driver failed
 USBCAN_ERR_DLL_TXFULL  = $0b;      // the message did not fit into the transmission queue
 USBCAN_ERR_MAXINSTANCES= $0c;      // maximum number of applications is reached
 USBCAN_ERR_CANNOTINIT  = $0d;      // CAN-interface is not yet initialized

// Error messages, that the module returns during the command sequence
 USBCAN_ERRCMD_NOTEQU   = $40;      // the received response does not match with the transmitted command
 USBCAN_ERRCMD_REGTST   = $41;      // no access to the CAN controler possible
 USBCAN_ERRCMD_ILLCMD   = $42;      // the module could not interpret the command
 USBCAN_ERRCMD_EEPROM   = $43;      // error while reading the EEPROM occured

// Warning messages, that can occur in the DLL
// NOTE: These messages are only warnings. The function has been executed anyway.
 USBCAN_WARN_NODATA        = $80;    // no CAN messages received
 USBCAN_WARN_SYS_RXOVERRUN = $81;    // overrun in the receive queue of the driver
 USBCAN_WARN_DLL_RXOVERRUN = $82;    // overrun in the receive queue of the DLL
 USBCAN_WARN_NULL_PTR      = $90;    // pointer to address is NULL (function will not work correctly)

// The Callback function is called, if certain events did occur.
// These Defines specify the event.
 USBCAN_EVENT_INITHW      = 0;       // the USB-CANmodule has been initialized
 USBCAN_EVENT_INITCAN     = 1;       // the CAN interface has been initialized
 USBCAN_EVENT_RECIEVE     = 2;       // a new CAN message has been received
 USBCAN_EVENT_STATUS      = 3;       // the error state in the module has changed
 USBCAN_EVENT_DEINITCAN   = 4;       // the CAN interface has been deinitialized (UcanDeinitCan() was called)
 USBCAN_EVENT_DEINITHW    = 5;       // the USB-CANmodule has been deinitialized (UcanDeinitHardware() was called)
 USBCAN_EVENT_CONNECT     = 6;       // a new USB-CANmodule has been connected
 USBCAN_EVENT_DISCONNECT  = 7;       // a USB-CANmodule has been disconnected
 USBCAN_EVENT_FATALDISCON = 8;       // a USB-CANmodule has been disconnected during operation

// CAN Error messages (is returned with UcanGetStatus() )
 USBCAN_CANERR_OK        = $0000;    // no error
 USBCAN_CANERR_XMTFULL   = $0001;    // Tx-buffer of the CAN controller is full
 USBCAN_CANERR_OVERRUN   = $0002;    // Rx-buffer of the CAN controller is full
 USBCAN_CANERR_BUSLIGHT  = $0004;    // Bus error: Error Limit 1 exceeded (refer to SJA1000 manual)
 USBCAN_CANERR_BUSHEAVY  = $0008;    // Bus error: Error Limit 2 exceeded (refer to SJA1000 manual)
 USBCAN_CANERR_BUSOFF    = $0010;    // Bus error: CAN controllerhas gone into Bus-Off state
 USBCAN_CANERR_QRCVEMPTY = $0020;    // RcvQueue is empty
 USBCAN_CANERR_QOVERRUN  = $0040;    // RcvQueue overrun
 USBCAN_CANERR_QXMTFULL  = $0080;    // transmit queue is full
 USBCAN_CANERR_REGTEST   = $0100;    // Register test of the SJA1000 failed
 USBCAN_CANERR_MEMTEST   = $0200;    // Memory test failed

// USB error messages (is returned with UcanGetStatus() )
 USBCAN_USBERR_OK  =  $0000;              // no error

// ABR and ACR for mode "receive all CAN messages"
 USBCAN_AMR_ALL:longword = $ffffffff;
 USBCAN_ACR_ALL:longword = $00000000;


 // set structure alignement to 1 byte
{$A-}
 // Typedef for the USB-CAN Handle
 type
 TCanArray = array[1..8] of byte;
 pUcanHandle =^tUcanHandle;
 tUcanHandle = byte;
// Typedef for the Callback function
tCallbackFkt = procedure( UcanHandle_p:tUcanHandle; bEvent_p:byte); stdcall;
// typedef void (PUBLIC *tCallbackFkt) (tUcanHandle UcanHandle_p, BYTE bEvent_p);

// Typedef for the Connection-Control function
tConnectControlFkt = procedure (bEvent_p: byte; dwParam_p:longword); stdcall;
// typedef void (PUBLIC *tConnectControlFkt) (BYTE bEvent_p, DWORD dwParam_p);

// Structure for the CAN message (suitable for CAN messages according to spec. CAN2.0B)
pCanMsgStruct=^tCanMsgStruct;
tCanMsgStruct = record
    m_dwID:longword;     // CAN Identifier
    m_bFF:byte;      // CAN Frame format (BIT7=1: 29BitID / BIT6=1: RTR-Frame)
    m_bDLC:byte;     // CAN Data Length Code
    m_bData: TCanArray; // CAN Data
    m_dwTime:longword;   // Time in ms
end;
    // NOTE:
    // Value of m_dwTime only is valid for received CAN messages. It is ignored for
    // CAN messages to send. Bits 0 until 23 contains time and bits 24 until 31 are
    // reserved.
// Structure with the stati (Function: UcanGetStatus())
pStatusStruct=^tStatusStruct;
tStatusStruct = record
    m_wCanStatus: word; // current CAN status
    m_wUsbStatus: word; // current USB status
end;

// Structure with the hardware properties of a USB-CANmodule (Function: UcanGetHardwareInf())
pUcanHardwareInfo=^tUcanHardwareInfo;
tUcanHardwareInfo = record
    m_bDeviceNr:byte;  // device number of the USB-CANmodule
    m_UcanHandle: tUcanHandle; // USB-CAN-Handle assigned by the DLL
    m_dwReserved: longword; // reserved
    m_bBTR0:byte;      // Bus Timing Register 0 (SJA1000)
    m_bBTR1:byte;      // Bus Timing Register 1 (SJA1000)
    m_bOCR:byte;       // Output Control Register (SJA1000)
    m_dwAMR: longword;      // Acceptance Mask Register (SJA1000)
    m_dwACR: longword;      // Acceptance Code Register (SJA1000)

    // new values since 17.03.03 Version V2.16
    m_bMode: byte;      // mode of CAN controller (see tUcanMode)
    m_dwSerialNr: longword; // serial number from USB-CANmodule
end;

// Structure with init parameters for function UcanInitCanEx()
pUcanInitCanParam=^tUcanInitCanParam; 
tUcanInitCanParam = record
    m_dwSize:longword;   // size of this structure
    m_bMode: byte;    // slecets the mode of CAN controller (see tUcanMode)
    m_bBTR0: byte;    // Bus Timing Register 0 (SJA1000)
    m_bBTR1: byte;    // Bus Timing Register 1 (SJA1000)
    m_bOCR: byte;     // Output Controll Register of SJA1000 (should be 0x1A)
    m_dwAMR: longword;    // Acceptance Mask Register (SJA1000)
    m_dwACR: longword;    // Acceptance Code Register (SJA1000)
end;

(*tUcanMode = (kUcanModeNormal = 0,    // normal mode (send and reciceive) (=0)
    kUcanModeListenOnly = 1);     // listen only mode (only reciceive)   (=1)
*)
// structure with transfered packet informations
pUcanMsgCountInfo=^tUcanMsgCountInfo;
tUcanMsgCountInfo = record
    m_wSentMsgCount: word;       // counter of sent CAN messages
    m_wRecvdMsgCount: word;      // counter of received CAN messages
end;

(*TUcanVersionType = ( kVerTypeUserDll = $0001 );          // =$0001
    *)

//---------------------------------------------------------------------------
// function prototypes
//---------------------------------------------------------------------------
// Function:    UcanGetVersion()
// Description: returns software version of USBCAN32.DLL
// Parameters:  none
// Returns:     software version
//                  format: Bits 0-7:   least significant version number (binary)
//                          Bits 8-15:  most significant version number (binary)
//                          Bits 16-30: reserved
//                          Bit 31:     1 = customer specific version
//---------------------------------------------------------------------------
 function UcanGetVersion:longword; stdcall; external 'USBCAN32.dll';

//---------------------------------------------------------------------------
// Function:    UcanGetVersionEx()
// Description: returns software version of different software modules
// Parameters:  VerType_p   = which version should be returned
//                            kVerTypeUserDll returnes Version of USBCAN32.DLL
//                            No more versions available at this time.
// Returns:     software version
//                  format: Bit 0-7:    Version
//                          Bit 8-15:   Revision
//                          Bit 16-31:  Release
// NOTE: If returned version is zero, then value of VerType_p
//       was unknown.
//---------------------------------------------------------------------------
//function UcanGetVersionEx (VerType_p:tUcanVersionType):longword;
//         stdcall; external 'USBCAN32.dll';

//---------------------------------------------------------------------------
// Function:    UcanInitHwConnectControl()
// Description: Initializes the Hardware-Connection-Control function
// Parameters:  fpConnectControlFkt_p = address to Hardware-Connection-Control function
// Returns:      USBCAN_SUCCESSFUL     USBCAN_ERR_RESOURCE
//---------------------------------------------------------------------------
function UcanInitHwConnectControl (fpConnectControlFkt_p:tConnectControlFkt):byte;
          stdcall; external 'USBCAN32.dll';

//---------------------------------------------------------------------------
// Function:    UcanDeinitHwConnectControl()
// Description: Deinitializes the Hardware-Connection-Control function
// Parameters:  none
// Returns:        USBCAN_SUCCESSFUL
//---------------------------------------------------------------------------
function UcanDeinitHwConnectControl: byte; stdcall; external 'USBCAN32.dll';

//---------------------------------------------------------------------------
// Function:    UcanInitHardware()
// Description: Initializes a USB-CANmodule with the device number x
// Parameters:  pUcanHandle_p = address pointing to the variable for the USB-CAN-Handle
//                  should not be ZERO!
//              bDeviceNr_p = device number of the USB-CANmodule
//                  valid values: 0 through 254
//                  USBCAN_ANY_MODULE: the first module that is found will be used
//              fpCallbackFkt_p = address of the Callback function
//                  NULL: no Callback function is used
// Returns:        USBCAN_SUCCESSFUL      USBCAN_ERR_MAXINSTANCES
//                 USBCAN_ERR_HWINUSE     USBCAN_ERR_ILLHW
//                 USBCAN_ERR_MAXMODULES  USBCAN_ERR_RESOURCE
//                 USBCAN_ERR_ILLVERSION
//---------------------------------------------------------------------------
function UcanInitHardware (pUcanHandle_p:pUcanHandle; bDeviceNr_p:byte; fpCallbackFkt_p:tCallbackFkt):byte;
         stdcall; external 'USBCAN32.dll';

//---------------------------------------------------------------------------
// Function:    UcanGetHardwareInfo()
// Description: Returns the hardware information of an initialized USB-CANmodule
// Parameters:  UcanHandle_p = USB-CAN-Handle
//                  Handle, which is returned by the function UcanInitHardware()
// Returns:         USBCAN_SUCCESSFUL      USBCAN_ERR_MAXINSTANCES
//                  USBCAN_ERR_ILLHANDLE   USBCAN_ERR_ILLPARAM
//---------------------------------------------------------------------------
function UcanGetHardwareInfo (UcanHandle_p:tUcanHandle; pHwInfo_p:pUcanHardwareInfo):byte;
         stdcall; external 'USBCAN32.dll';

//---------------------------------------------------------------------------
// Function:    UcanDeinitHardware()
// Description: Deinitializes a USB-CANmodule
// Parameters:  UcanHandle_p = USB-CAN-Handle
//                  Handle, which is returned by the function UcanInitHardware()
// Returns:         USBCAN_SUCCESSFUL      USBCAN_ERR_MAXINSTANCES
//                  USBCAN_ERR_ILLHANDLE
//---------------------------------------------------------------------------
function UcanDeinitHardware (UcanHandle_p:tUcanHandle):byte;   
     stdcall; external 'USBCAN32.dll';

//---------------------------------------------------------------------------
// Function:    UcanInitCan()
// Description: Initializes the CAN interface on the USB-CANmodule
// Parameters:  UcanHandle_p = USB-CAN-Handle
//                  Handle, which is returned by the function UcanInitHardware()
//              bBTR0_p = Baudrate Register 0 (SJA1000)
//              bBTR1_p = Baudrate Register 1 (SJA1000)
//              dwAMR_p = Acceptance Filter Mask (SJA1000)
//              dwACR_p = Acceptance Filter Code (SJA1000)
// Returns:       USBCAN_SUCCESSFUL      USBCAN_ERR_MAXINSTANCES
//                USBCAN_ERR_ILLHANDLE   USBCAN_ERR_RESOURCE
//                USBCAN_ERR_BUSY        USBCAN_ERR_IOFAILED
//                USBCAN_ERRCMD_NOTEQU   USBCAN_ERRCMD_REGTST
//                USBCAN_ERRCMD_ILLCMD
//---------------------------------------------------------------------------
function UcanInitCan (UcanHandle_p:tUcanHandle; bBTR0_p, bBTR1_p:byte; dwAMR_p, dwACR_p:longword):byte;
         stdcall; external 'USBCAN32.dll';

//---------------------------------------------------------------------------
// Function:    UcanInitCanEx()
// Description: Initializes the CAN interface on the USB-CANmodule with additional parameters
// Parameters:  UcanHandle_p = USB-CAN-Handle
//                  Handle, which is returned by the function UcanInitHardware()
//              pInitCanParam_p = pointer to init parameter structure
// Returns:      USBCAN_SUCCESSFUL       USBCAN_ERR_MAXINSTANCES
//               USBCAN_ERR_ILLHANDLE    USBCAN_ERR_RESOURCE
//               USBCAN_ERR_BUSY         USBCAN_ERR_IOFAILED
//               USBCAN_ERRCMD_NOTEQU    USBCAN_ERRCMD_REGTST
//               USBCAN_ERRCMD_ILLCMD
//---------------------------------------------------------------------------
function UcanInitCanEx (UcanHandle_p:tUcanHandle; pInitCanParam_p:pUcanInitCanParam):byte;
           stdcall; external 'USBCAN32.dll';
           
//---------------------------------------------------------------------------
// Function:    UcanResetCan()
// Description: Resets the CAN interface (Hardware-Reset, empty buffer, ...)
// Parameters:  UcanHandle_p = USB-CAN-Handle
//                  Handle, which is returned by the function UcanInitHardware()
// Returns:      USBCAN_SUCCESSFUL     USBCAN_ERR_MAXINSTANCES
//               USBCAN_ERR_ILLHANDLE  USBCAN_ERR_CANNOTINIT
//               USBCAN_ERR_BUSY       USBCAN_ERR_IOFAILED
//               USBCAN_ERRCMD_NOTEQU  USBCAN_ERRCMD_ILLCMD
//---------------------------------------------------------------------------
function UcanResetCan (UcanHandle_p:tUcanHandle): byte;
         stdcall; external 'USBCAN32.dll';
         
//---------------------------------------------------------------------------
// Function:    UcanReadCanMsg()
// Description: Reads a CAN message
// Parameters:  UcanHandle_p = USB-CAN-Handle
//                  Handle, which is returned by the function UcanInitHardware()
//              pCanMsg_p = pointer to the CAN message structure
// Returns:      USBCAN_SUCCESSFUL          USBCAN_ERR_MAXINSTANCES
//               USBCAN_ERR_ILLHANDLE       USBCAN_ERR_CANNOTINIT
//               USBCAN_ERR_ILLPARAM        USBCAN_WARN_NODATA
//               USBCAN_WARN_SYS_RXOVERRUN  USBCAN_WARN_DLL_RXOVERRUN
//---------------------------------------------------------------------------
function UcanReadCanMsg (UcanHandle_p:tUcanHandle; pCanMsg_p:pCanMsgStruct):byte;
         stdcall; external 'USBCAN32.dll';
         
//---------------------------------------------------------------------------
// Function:    UcanWriteCanMsg()
// Description: Sends a CAN message
// Parameters:  UcanHandle_p = USB-CAN-Handle
//                  Handle, which is returned by the function UcanInitHardware()
//              pCanMsg_p = pointer to the CAN message structure
// Returns:       USBCAN_SUCCESSFUL     USBCAN_ERR_MAXINSTANCES
//                USBCAN_ERR_ILLHANDLE  USBCAN_ERR_CANNOTINIT
//                USBCAN_ERR_ILLPARAM   USBCAN_ERR_DLL_TXFULL
//---------------------------------------------------------------------------
function UcanWriteCanMsg(UcanHandle_p:tUcanHandle; pCanMsg_p:pCanMsgStruct):byte; 
         stdcall; external 'USBCAN32.dll';
         
//---------------------------------------------------------------------------
// Function:    UcanGetStatus()
// Description: Returns the state of the USB-CANmodule
// Parameters:  UcanHandle_p = USB-CAN-Handle
//                  Handle, which is returned by the function UcanInitHardware()
//              pStatus_p = pointer to Status structure
// Returns:       USBCAN_SUCCESSFUL      USBCAN_ERR_MAXINSTANCES
//                USBCAN_ERR_ILLHANDLE   USBCAN_ERR_ILLPARAM
//---------------------------------------------------------------------------
function UcanGetStatus (UcanHandle_p:tUcanHandle; pStatus_p:pStatusStruct):byte;
         stdcall; external 'USBCAN32.dll';

//---------------------------------------------------------------------------
// Function:    UcanGetMsgCountInfo()
// Description: Reads the packet information from USB-CANmodule (counter of
//              received and sent CAN messages).
// Parameters:  UcanHandle_p = USB-CAN-Handle
//                  Handle, which is returned by the function UcanInitHardware()
//              pMsgCountInfo_p = pointer to message counter information structure
// Returns:      USBCAN_SUCCESSFUL     USBCAN_ERR_MAXINSTANCES
//               USBCAN_ERR_ILLHANDLE  USBCAN_ERR_CANNOTINIT
//               USBCAN_ERR_BUSY       USBCAN_ERR_IOFAILED
//               USBCAN_ERRCMD_NOTEQU  USBCAN_ERRCMD_ILLCMD
//---------------------------------------------------------------------------

function UcanGetMsgCountInfo(UcanHandle_p:tUcanHandle; pMsgCountInfo_p:pUcanMsgCountInfo):byte;
        stdcall; external 'USBCAN32.dll';

//---------------------------------------------------------------------------
// Function:    UcanDeinitCan()
// Description: Shuts down the CAN interface on the USB-CANmodule
// Parameters:  UcanHandle_p = USB-CAN-Handle
//                  Handle, which is returned by the function UcanInitHardware()
// Returns:      USBCAN_SUCCESSFUL     USBCAN_ERR_MAXINSTANCES
//               USBCAN_ERR_ILLHANDLE  USBCAN_ERR_CANNOTINIT
//               USBCAN_ERR_BUSY       USBCAN_ERR_IOFAILED
//               USBCAN_ERRCMD_NOTEQU  USBCAN_ERRCMD_ILLCMD
// State:       
//---------------------------------------------------------------------------
function UcanDeinitCan ( UcanHandle_p:tUcanHandle):byte;
        stdcall; external 'USBCAN32.dll';
         

implementation
 
end.
 