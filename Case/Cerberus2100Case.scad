EnableBox=1;
EnableLid=1;
EnableCAT=1;

BoardWidth=143.28;
BoardDepth=111.42;
BoardHeight=16;
UnderBoardGap=2.8;
BoardThickness=1.6;

CATWidth=15.8;
CATHeight=2.6;
CATOffset=0.5;
CATBoardWidth=18;

SDCardWidth=12.5;
SDCardInternalHeight=2.5;
SDCardExternalHeight=5.5;
SDCardOffset=20.5;

VGAWidth=30.6;
VGAHeight=12.5;
VGAOffset=49.3;

PowerWidth=9.1;
PowerHeight=3.2;
PowerOffset=BoardWidth-PowerWidth-23.9;

KeyboardWidth=14.4;
KeyboardHeight=7.5;
KeyboardOffset=BoardWidth-KeyboardWidth-7.5;

WallWidth=2;
FingerGap=10;
ExpansionGap=0.2;

HoleDiameter=2.7;
NutDiameter=6.2;
NutHeight=2.5;
StandTopThickness=1.8;
StandBotThickness=2.0+(NutDiameter-HoleDiameter)/2;

HoleCornerDistance=4;
BottomRightHoleDistance=14.7;
BottomCentreHoleX=64;
BottomCentreHoleDistance=8;

LidHeight=4.2;
LidRunnerWidth = 1.0;
LidRunnerHeight = 3.0;
LidRunnerExpansion=0.1;
LidRunnerTopExpansion=0.2;

LogoThickness=1.0;
LogoScale=2/3;
LogoVirtOffset=8;
TextSize=14;
TextVirtOffset=-48;

Embed=0.001;

CavityWidth=BoardWidth+FingerGap;
CavityDepth=BoardDepth;
CavityHeight=BoardHeight+UnderBoardGap;

$fn=64;

StandPositions = [
    [FingerGap+HoleCornerDistance,HoleCornerDistance],
    [FingerGap+HoleCornerDistance,BoardDepth-HoleCornerDistance],
    [FingerGap+BoardWidth-HoleCornerDistance,BoardDepth-HoleCornerDistance],
    [FingerGap+BoardWidth-BottomRightHoleDistance,HoleCornerDistance],
    [FingerGap+BottomCentreHoleX,BottomCentreHoleDistance],
];

module BoardStand(x,y)
{
    holeRadius = HoleDiameter/2;
    standTopRadius = holeRadius+StandTopThickness;
    standBotRadius = holeRadius+StandBotThickness;
    translate([x,y,-Embed])
    {
        cylinder(UnderBoardGap+Embed, standBotRadius, standTopRadius);
    }
}

module BoardStandHole(x,y)
{
    holeRadius = HoleDiameter/2;
    translate([x,y,-WallWidth-Embed])
    {
        cylinder(UnderBoardGap+WallWidth+Embed*2, holeRadius, holeRadius);
        cylinder(NutHeight+Embed, NutDiameter/2, NutDiameter/2, $fn=6);
    }
}

module Lid(x,y,z,expand)
{
    localEmbed = expand == 0 ? 0 : Embed;
    shrink = expand == 0 ? LidRunnerExpansion : 0;
    shrinkTop = expand == 0 ? LidRunnerTopExpansion : 0;

    translate([x-WallWidth-localEmbed,-WallWidth-localEmbed,z])
    {
        union()
        {
            difference()
            {

                cube([CavityWidth+(WallWidth+localEmbed)*2, CavityDepth+(WallWidth+localEmbed)*2, LidHeight]);
                translate([WallWidth-LidRunnerWidth-shrink,WallWidth-LidRunnerWidth-shrink,-Embed*2])
                {
                    difference()
                    {
                        cube([CavityWidth+LidRunnerWidth*2+shrink*2, CavityDepth+LidRunnerWidth*2+shrink*2, LidRunnerHeight+shrinkTop-Embed*2]);
                        translate([LidRunnerWidth+shrink*2,LidRunnerWidth-ExpansionGap+shrink*2,-Embed])
                        {
                        cube([CavityWidth-shrink*2, CavityDepth+ExpansionGap*2-shrink*2, LidRunnerHeight+shrinkTop+Embed]);
                        }
                    }
                }

            }
            if (expand == 0)
            {
                translate([CavityWidth/2,CavityDepth/2,0])
                {
                    translate([0,LogoVirtOffset,LidHeight-Embed])
                    {
                        scale([LogoScale,LogoScale,0.01*(LogoThickness+Embed)])
                        {
                            surface("lidlogo.png", center = true);
                        }
                    }
                    translate([0,TextVirtOffset,LidHeight-Embed])
                    {
                        linear_extrude(LogoThickness+Embed)
                        {
                            text("Cerberus 2100", size=TextSize, halign="center", font="Arial:style=Regular");
                        }
                    }
                }
            }
        }
    }
}

if (EnableBox)
{
    difference()
    {
        union()
        {
            // Main box
            difference()
            {
                translate([-WallWidth,-WallWidth,-WallWidth])
                {
                    cube([CavityWidth+WallWidth*2, CavityDepth+WallWidth*2, CavityHeight+WallWidth+LidHeight-Embed]);
                }
                translate([0,-ExpansionGap,0])
                {
                    cube([CavityWidth, CavityDepth+ExpansionGap*2, CavityHeight+Embed]);
                }
            }

            // Stands
            for (position = StandPositions)
            {
                BoardStand(position[0], position[1]);
            }
        }

        // Stand holes
        for (position = StandPositions)
        {
            BoardStandHole(position[0], position[1]);
        }

        // VGA
        translate([FingerGap+VGAOffset,BoardDepth-Embed,UnderBoardGap+BoardThickness])
        {
            cube([VGAWidth, WallWidth+Embed*2, VGAHeight]);
        }

        // Power
        translate([FingerGap+PowerOffset,BoardDepth-Embed,UnderBoardGap+BoardThickness])
        {
            cube([PowerWidth, WallWidth+Embed*2, PowerHeight]);
        }

        // Keyboard
        translate([FingerGap+KeyboardOffset,BoardDepth-Embed,UnderBoardGap+BoardThickness])
        {
            cube([KeyboardWidth, WallWidth+Embed*2, KeyboardHeight]);
        }

        // CAT
        if (EnableCAT)
        {
            translate([FingerGap+BoardWidth-Embed,CATOffset,UnderBoardGap+BoardThickness])
            {
                cube([WallWidth+Embed*2, CATWidth, CATHeight]);
            }
            translate([FingerGap+BoardWidth-Embed,CATOffset-(CATBoardWidth-CATWidth)/2,UnderBoardGap+BoardThickness-100+Embed])
            {
                cube([WallWidth+Embed*2, CATBoardWidth, 100]);
            }
        }

        // SD card
        translate([FingerGap+BoardWidth-Embed,SDCardOffset,UnderBoardGap+BoardThickness])
        {
            hull()
            {
                cube([Embed, SDCardWidth, SDCardInternalHeight]);
                translate([WallWidth+Embed,0,(SDCardInternalHeight-SDCardExternalHeight)/2])
                cube([Embed, SDCardWidth, SDCardExternalHeight]);
            }
        }

        // Lid runners
        Lid(0,0,CavityHeight, LidRunnerExpansion);
    }
}

//Lid(0,-WallWidth,CavityHeight, 0);

if (EnableLid)
{
    translate([0,150,0]) Lid(0,0,0,0);
}