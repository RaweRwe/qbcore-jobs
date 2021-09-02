Config = {}

Config.JobStart = {
	{ ["x"] = 5.35, ["y"] = -1605.19, ["z"] = 29.39, ["h"] = 0 },
}

Config.JobStartGreen = {
	{ ["x"] = 11.24, ["y"] = -1605.64, ["z"] = 29.39, ["h"] = 0 },
}

Config.PickUpStuff = {
	{ ["x"] = 650.68, ["y"] = 2727.25, ["z"] = 41.99, ["h"] = 0 },
}

Config.PaymentTaco = math.random(100, 140)

Config.JobBusy = false

Config.JobData = {
 ['tacos'] = 0,
 ['register'] = 0,
 ['stock-lettuce'] = 0,
 ['stock-meat'] = 0,
 ['green-tacos'] = 110,
 ['locations'] = {
    [1] = {
	  ['name'] = 'Lettuce', 
	  x = 16.93,
	  y = -1599.72,
	  z = 29.377,
	},
	[2] = {
	  ['name'] = 'Meat', 
	  x = 11.31,
	  y = -1599.34,
	  z = 29.377,
	},
	[3] = {
	  ['name'] = 'Shell', 
	  x = 13.18,
	  y = -1597.30,
	  z = 29.377,
	},
	[4] = {
		['name'] = 'Register', 
		x = 9.44,
		y = -1605.16,
		z = 29.377,
	  },
	[5] = {
		['name'] = 'GiveTaco', 
		x = 7.18,
		y = -1604.90,
		z = 29.377,
	  },
	  [6] = {
		['name'] = 'Stock', 
		x = 20.10,
		y = -1602.16,
		z = 29.377,
	  },
  },
}