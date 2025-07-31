<h1 align="center">Bonk 1.1.0</h1>

<p align="center">3D collisions for GameMaker 2024.11 by <a href="https://www.jujuadams.com/" target="_blank">Juju Adams</a></p>

<p align="center"><a href="https://github.com/JujuAdams/bonk/releases/">Download the .yymps</a></p>

&nbsp;

Bonk is a 3D collision library. It supports boolean "inside" tests between shapes as well as "push out" tests. Bonk also has functions for raycasting. The library contains basic collision mechanics suitable for most types of 3D games - shooters, platforms, RPGs etc.

Please note that cylinders and capsule are z-aligned and cannot be rotated. Additionally, rotated boxes can only be rotated around the z-axis.

<table>
    <tr>
        <td align="center"></td>
        <td align="center">AABB</td>
        <td align="center">Capsule</td>
        <td align="center">Cylinder</td>
        <td align="center">Quad</td>
        <td align="center">Rotated Box</td>
        <td align="center">Sphere</td>
        <td align="center">Triangle</td>
        <td align="center">Line/Ray</td>
        <td align="center">Point</td>
    </tr>
    <tr>
        <td align="right">AABB</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
    </tr>
    <tr>
        <td align="right">Capsule</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
    </tr>
    <tr>
        <td align="right">Cylinder</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
        <td align="center">✓</td> 
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
    </tr>
    <tr>
        <td align="right">Quad</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
    </tr>
    <tr>
        <td align="right">Rotated Box</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
    </tr>
    <tr>
        <td align="right">Sphere</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
    </tr>
    <tr>
        <td align="right">Triangle</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
    </tr>
    <tr>
        <td align="right">Line/Ray</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
    </tr>
    <tr>
        <td align="right">Point</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
        <td align="center">✓</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
        <td align="center">☒</td>
    </tr>
</table>

You may also be interested in [Dragonite's 3D Collisions](https://dragonite.itch.io/collisions). Dragonite also has many videos on [3D topics](https://youtube.com/@DragoniteSpam?feature=shared) in GameMaker.
