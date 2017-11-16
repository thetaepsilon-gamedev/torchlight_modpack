# handheld\_torch: register items to cast light when held by a player

A mod which utilises my libmt_wieldhooks and lightentity mods
(thay can be found at at https://github.com/thetaepsilon-gamedev/)
to allow items to cast light when held by a player.
The movement update interval is set so that the re-lighting load is not too burdensome,
though YMMV and you should probably performance test this if you want to use it.

This mod by itself only registers one item for this mechanism: default:torch.
Enable this mod and it's dependencies and switch to a torch in your hotbar in-game to see the effect.
