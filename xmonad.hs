import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
-- for the volume media keys
import Graphics.X11.ExtraTypes.XF86


-- real Goerzen config style
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaultConfig
    { manageHook = manageDocks <+> manageHook defaultConfig,
      layoutHook = avoidStruts  $  layoutHook defaultConfig,
      logHook = dynamicLogWithPP xmobarPP
                  { ppOutput = hPutStrLn xmproc,
                    ppTitle = xmobarColor "green" "" . shorten 100
                  },
      terminal = "urxvt",
      modMask = mod4Mask
    } `additionalKeys`
    [ ((mod4Mask .|. controlMask, xK_l), spawn "slock"),
      ((0, xK_Print), spawn "scrot -e 'mv $f ~/screencaps/'"),
      ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 2dB-" >>
                                     spawn "play -v 1.0 ~/.xmonad-resources/sound-change-beep.wav"),
      ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 2dB+" >>
                                     spawn "play -v 1.0 ~/.xmonad-resources/sound-change-beep.wav"),
      ((0, xF86XK_AudioMute),        spawn "amixer set Master toggle")
    ]
