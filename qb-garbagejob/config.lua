Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DEL'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = {}

Config.BailPrice = 1000

Config.Locations = {
    ["main"] = {
        label = "Garbage Dump",
        coords = {x = -350.08, y = -1569.95, z = 25.22, h = 292.42},
    },
    ["vehicle"] = {
        label = "Garbage Truck Storage",
        coords = {x = -340.74, y = -1561.82, z = 25.23, h = 58.0},
    },
    ["paycheck"] = {
        label = "PayCheck",
        coords = {x = -346.68, y = -1572.39, z = 25.22, h = 163.5, r = 1.0}, 
    },
    ["vuilnisbakken"] ={
        [1] = {
            name = "forumdrive",
            coords = {x = -168.07, y = -1662.8, z = 33.31, h = 137.5},
        },
        [2] = {
            name = "grovestreet",
            coords = {x = 118.06, y = -1943.96, z = 20.43, h = 179.5},
        },
        [3] = {
            name = "jamestownstreet",
            coords = {x = 297.94, y = -2018.26, z = 20.49, h = 119.5},
        },
        [4] = {
            name = "roylowensteinblvd",
            coords = {x = 509.99, y = -1620.98, z = 29.09, h = 0.5},
        },
        [5] = {
            name = "littlebighornavenue",
            coords = {x = 488.49, y = -1284.1, z = 29.24, h = 138.5},
        },
        [6] = {
            name = "vespucciblvd",
            coords = {x = 307.47, y = -1033.6, z = 29.03, h = 46.5},
        },
        [7] = {
            name = "elginavenue",
            coords = {x = 239.19, y = -681.5, z = 37.15, h = 178.5},
        },
        [8] = {
            name = "elginavenue2",
            coords = {x = 543.51, y = -204.41, z = 54.16, h = 199.5},
        },
        [9] = {
            name = "powerstreet",
            coords = {x = 268.72, y = -25.92, z = 73.36, h = 90.5},
        },
        [10] = {
            name = "altastreet",
            coords = {x = 267.03, y = 276.01, z = 105.54, h = 332.5},
        },
        [11] = {
            name = "didiondrive",
            coords = {x = 21.65, y = 375.44, z = 112.67, h = 323.5},
        },
        [12] = {
            name = "miltonroad",
            coords = {x = -546.9, y = 286.57, z = 82.85, h = 127.5},
        },
        [13] = {
            name = "eastbourneway",
            coords = {x = -683.23, y = -169.62, z = 37.74, h = 267.5},
        },
        [14] = {
            name = "eastbourneway2",
            coords = {x = -771.02, y = -218.06, z = 37.05, h = 277.5},
        },
        [15] = {
            name = "industrypassage",
            coords = {x = -1057.06, y = -515.45, z = 35.83, h = 61.5},
        },
        [16] = {
            name = "boulevarddelperro",
            coords = {x = -1558.64, y = -478.22, z = 35.18, h = 179.5, r = 1.0},
        },
        [17] = {
            name = "sandcastleway",
            coords = {x = -1350.0, y = -895.64, z = 13.36, h = 17.5},
        },
        [18] = {
            name = "magellanavenue",
            coords = {x = -1243.73, y = -1359.72, z = 3.93, h = 287.5},
        },
        [19] = {
            name = "palominoavenue",
            coords = {x = -845.87, y = -1113.07, z = 6.91, h = 253.5},
        },
        [20] = {
            name = "southrockforddrive",
            coords = {x = -635.21, y = -1226.45, z = 11.8, h = 143.5},
        },
        [21] = {
            name = "southarsenalstreet",
            coords = {x = -587.74, y = -1739.13, z = 22.47, h = 339.5},
        },
    },
}

Config.Vehicles = {
    ["trash2"] = "Garbage Truck",
}