#!/usr/local/bin/ruby

require 'Win32API'

module Clipboard

# Clipboard API
$OpenClipboard = Win32API.new('user32', 'OpenClipboard', ['I'], 'I');
$CloseClipboard = Win32API.new('user32', 'CloseClipboard', [], 'I');
$EmptyClipboard = Win32API.new('user32', 'EmptyClipboard', [], 'I');
$IsClipboardFormatAvailable = Win32API.new('user32', 'IsClipboardFormatAvailable', ['I'], 'I');
$GetClipboardData = Win32API.new('user32', 'GetClipboardData', ['I'], 'I');
$SetClipboardData = Win32API.new('user32', 'SetClipboardData', ['I', 'I'], 'I');
# Predefined Clipboard Formats
CF_TEXT = 1;
CF_BITMAP = 2;
CF_METAFILEPICT = 3;
CF_SYLK = 4;
CF_DIF = 5;
CF_TIFF = 6;
CF_OEMTEXT = 7;
CF_DIB = 8;
CF_PALETTE = 9;
CF_PENDATA = 10;
CF_RIFF = 11;
CF_WAVE = 12;
CF_UNICODETEXT = 13;
CF_ENHMETAFILE = 14;
CF_HDROP = 15;
CF_LOCALE = $10;
CF_MAX = 17;


# memory manager API
$GlobalAlloc = Win32API.new('kernel32', 'GlobalAlloc', ['I','I'], 'I');
$GlobalSize = Win32API.new('kernel32', 'GlobalSize', ['I'], 'I');
$GlobalLock = Win32API.new('kernel32', 'GlobalLock', ['I'], 'P');
$GlobalUnlock = Win32API.new('kernel32', 'GlobalUnlock', ['I'], 'I');
$GlobalFree = Win32API.new('kernel32', 'GlobalFree', ['I'], 'I');

# Global Memory Flags
GMEM_FIXED = 0;
GMEM_MOVEABLE = 2;
GMEM_NOCOMPACT = 0x10;
GMEM_NODISCARD = 0x20;
GMEM_ZEROINIT = 0x40;
GMEM_MODIFY = 0x80;
GMEM_DISCARDABLE = 0x100;
GMEM_NOT_BANKED = 0x1000;
GMEM_SHARE = 0x2000;
GMEM_DDESHARE = 0x2000;
GMEM_NOTIFY = 0x4000;
GMEM_LOWER = GMEM_NOT_BANKED;
GMEM_VALID_FLAGS = 32626;
GMEM_INVALID_HANDLE = 0x8000;

GHND = GMEM_MOVEABLE + GMEM_ZEROINIT;
GPTR = GMEM_FIXED + GMEM_ZEROINIT;

$lstrcpy = Win32API.new('kernel32', 'lstrcpyA', ['P', 'P'], 'P');
$lstrlen = Win32API.new('kernel32', 'lstrlenA', ['P'], 'I');

$lstrcpyIP = Win32API.new('kernel32', 'lstrcpyA', ['I', 'P'], 'P');
$lstrcpyPI = Win32API.new('kernel32', 'lstrcpyA', ['P', 'I'], 'P');
$GlobalLockI = Win32API.new('kernel32', 'GlobalLock', ['I'], 'I');


  def GetText
    result = ""
    if $OpenClipboard.Call(0) != 0
      if (h = $GetClipboardData.Call(CF_TEXT)) != 0
        if (p = $GlobalLock.Call(h)) != 0
          result = p;
          $GlobalUnlock.Call(h);
        end
      end
      $CloseClipboard.Call;
    end
    return result;
  end
  
  def SetText(text)
    if (text == nil) || (text == "")
      return
    end
    if $OpenClipboard.Call(0) != 0
      $EmptyClipboard.Call();
      len = $lstrlen.Call(text);
      hmem = $GlobalAlloc.Call(GMEM_DDESHARE, len+1);
      pmem = $GlobalLockI.Call(hmem);
      $lstrcpyIP.Call(pmem, text);
      $SetClipboardData.Call(CF_TEXT, hmem);
      $GlobalUnlock.Call(hmem);
      $CloseClipboard.Call;
    end
  end
end

include Clipboard;

# sample:
#   require 'clipbrd';
#   print Clipboard.GetText;
#   Clipboard.SetText("aaaaa\nbbbbb\n");
