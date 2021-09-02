Config = {}

Config.AttachedVehicle = nil

Config.Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config.AuthorizedIds = {
	"ILH21727",
	"DXK99147",
	"LSH49123",
	"EIG94280",
	"BEZ11455",
	"FAQ74860",
	"WQC05904",
	"KXM24705",
	"DXK99147",
	"VMB70477",
	"LYA93600",
	"OWR42552",
	"SGS45725",
	"JTU70151",
}

Config.MaxStatusValues = {
    ["engine"] = 1000.0,
    ["body"] = 1000.0,
    ["radiator"] = 100,
    ["axle"] = 100,
    ["brakes"] = 100,
    ["clutch"] = 100,
    ["fuel"] = 100,
}

Config.ValuesLabels = {
    ["engine"] = "Motor",
    ["body"] = "Carrosserie",
    ["radiator"] = "Radiator",
    ["axle"] = "Aandrijfas",
    ["brakes"] = "Remmen",
    ["clutch"] = "Schakelbak",
    ["fuel"] = "Brandstoftank",
}

Config.RepairCost = {
    ["body"] = "plastic",
    ["radiator"] = "plastic",
    ["axle"] = "steel",
    ["brakes"] = "iron",
    ["clutch"] = "aluminum",
    ["fuel"] = "plastic",
}

Config.RepairCostAmount = {
    ["engine"] = {
        item = "metalscrap",
        costs = 2,
    },
    ["body"] = {
        item = "plastic",
        costs = 3,
    },
    ["radiator"] = {
        item = "steel",
        costs = 5,
    },
    ["axle"] = {
        item = "aluminum",
        costs = 7,
    },
    ["brakes"] = {
        item = "copper",
        costs = 5,
    },
    ["clutch"] = {
        item = "copper",
        costs = 6,
    },
    ["fuel"] = {
        item = "plastic",
        costs = 5,
    },
}

Config.Businesses = {
    "autocare",
}

Config.Plates = {
    [1] = {
        coords = {x = -319.41, y = -119.73, z = 39.01, h = 70.76, r = 1.0},
        AttachedVehicle = nil,
    },
    [2] = {
        coords = {x = -321.61, y = -125.77, z = 38.98, h = 69.01, r = 1.0}, 
        AttachedVehicle = nil,
    },
    [3] = {
        coords = {x = -324.42, y = -131.6, z = 38.96, h = 71.16, r = 1.0}, 
        AttachedVehicle = nil,
    },
    [4] = {
        coords = {x = -333.33, y = -118.17, z = 39.02, h = 250.76, r = 1.0}, 
        AttachedVehicle = nil,
    },
}
Config.Locations = {
    ["exit"] = {x = -341.425, y = -120.529, z = 39.49, h = 70.5, r = 1.0},
    ["stash"] = {x = -345.8361, y = -110.9983, z = 39.01, h = 73, r = 1.0},
    ["duty"] = {x = -346.925, y = -128.6472, z = 39.01, h = 80, r = 1.0},
    ["vehicle"] = {x = -363.0823, y = -119.865, z = 38.69924, h = 75, r = 1.0}, 
    ['boss'] = {x = -305.9205, y = -120.9122, z = 39.009487, h = 161.84399, r = 1.0},
}

Config.Vehicles = {
    ["towtruck"] = "Towtruck",
    ["flatbed3"] = "Afsleep wagen",
    ["burrito4"] = "Werkbus",
    ["minivan"] = "Minivan (Leen Auto)",
    ["blista"] = "Blista",
}

Config.MinimalMetersForDamage = {
    [1] = {
        min = 8000,
        max = 12000,
        multiplier = {
            min = 1,
            max = 8,
        }
    },
    [2] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 8,
            max = 16,
        }
    },
    [3] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 16,
            max = 24,
        }
    },
}

Config.Damages = {
    ["radiator"] = "Radiator",
    ["axle"] = "Aandrijfas",
    ["brakes"] = "Remmen",
    ["clutch"] = "Schakelbak",
    ["fuel"] = "Brandstoftank",
}