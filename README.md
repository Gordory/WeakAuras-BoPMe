To ASK blessing of protection you must use this macro:
`/run WeakAuras.ScanEvents("ASK_BOP")`

Ask/Give BoP weakaura for paladins was made by Gordory#3993 @ Discord  https://wago.io/p/Gordory

All credits for base WeakAura goes to: Buds#0500 @ Discord - https://wago.io/p/Buds

update: 09/06/2020

Features!

For paladins:

1. It works out of the box!
2. Icon and sound indication for asking BoP with class-colored name who asked it
3. Raid-frame indication (tested and works perfectly with blizzard frames, healbot and vuhdo)
4. If u can't give BoP cause you're very-very busy - just ignore it, and another paladin will take the next request (if DD still be alive)
5. You never get the request when your BoP is on cooldown or you too far away or even if you are dead
6. There is built-in simple load distribution for paladins. All pals in raid will take about the same amount of requests from raiders
7. If you are tank or some extremely important person you can ask raiders to blacklist you in aura user-configs


For raid-members:

1. You need to make request macros with /run WeakAuras.ScanEvents("ASK_BOP")
2. Indication of request. Icon with name who got this request
3. Sending request only to alive paladins in raid, without a BoP cooldown and in range
4. Sound indication of failed request - if paladins BoP is on CD (rare situation, for example if u reloaded your interface and your variables was cleaned). If you got that indication - you can press macros one more time and request will be sent to another available paladin.
5. Indication of recieved BoP. Sound and icon with remaining BoP time
6. If you don't want to ask some paladin to BoP you - just blacklist him in your aura user-config
7. If there are no available paladins OR you got Forbearance debuff there will be no request indication and you can press your Invulnerability potion. For example it can be made with shift modifier by this macros:
```
#showtooltip
/use [mod:shift, combat] item: 3387
/stopmacro [mod:shift]
/run WeakAuras.ScanEvents("ASK_BOP")
```

Feel free to use!
