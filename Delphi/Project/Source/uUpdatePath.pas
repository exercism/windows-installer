unit uUpdatePath;

interface

type
  TUpdatePath = class
    class procedure BroadcastChange;
    class function AddToPath(aDir: string): Boolean;
    class function RemoveFromPath(aDir: string): Boolean;
  end;

implementation
{$ifdef MSWINDOWS}
uses System.SysUtils, windows, Winapi.Messages, Registry;
{$endif}

class function TUpdatePath.AddToPath(aDir: string): Boolean;
begin
  result := false;
  var reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    var openResult := reg.OpenKeyReadOnly('Environment');
    if openResult then
    begin
      var lPath:= reg.ReadString('Path');
      if lPath.ToLower.Contains(aDir.ToLower) then
        result := true
      else
      begin
        reg.CloseKey;
        reg.Access := KEY_WRITE;
        openResult := reg.OpenKey('Environment', true);
        if openResult then
        begin
          if not lPath.EndsWith(';') then
            lPath := lPath + ';';
          lPath := lPath + aDir;
          reg.WriteString('Path',lPath);
          BroadcastChange;
          result := true;
        end;
      end;
    end
    else
      result := false;
  finally
    reg.CloseKey;
    reg.Free;
  end;
end;

class procedure TUpdatePath.BroadcastChange;
var
  lP: LPARAM;
  wP: WPARAM;
  Buf : Array[0..10] of Char;
  aResult: DWORD;//Cardinal;
begin
  Buf := 'Environment';
  wP := 0;
  lP := integer(@Buf[0]);

  SendMessageTimeout(HWND_BROADCAST,
                     WM_SETTINGCHANGE,
                     wP,
                     lP,
                     SMTO_ABORTIFHUNG{SMTO_NORMAL},
                     5000{4000},
                     aResult);
  if aResult <> 0 then
    SysErrorMessage(aResult);
end;

class function TUpdatePath.RemoveFromPath(aDir: string): Boolean;
begin
  result := false;
  var reg := TRegistry.Create;
  try
    reg.RootKey := {HKEY_LOCAL_MACHINE{} HKEY_CURRENT_USER{};
    var openResult := reg.OpenKeyReadOnly('Environment');
    if openResult then
    begin
      var lPath:= reg.ReadString('Path');
      if lPath.ToLower.Contains(aDir.ToLower) then
      begin
        var lSplitPath: TArray<string> := lPath.Split([';']);
        var lNewPath := '';
        for var lDir in lSplitPath do
        begin
          if lDir.ToLower <> aDir.ToLower then
            if lNewPath.IsEmpty then
              lNewPath := lDir
            else
              lNewPath := lNewPath + ';' + lDir;
        end;
        reg.CloseKey;
        reg.Access := KEY_WRITE;
        openResult := reg.OpenKey('Environment', true);
        if openResult then
        begin
          reg.WriteString('Path',lNewPath);
          BroadcastChange;
          result := true;
        end;
      end
      else
        result := true;
    end
    else
      result := false;
  finally
    reg.CloseKey;
    reg.Free;
  end;
end;

end.
