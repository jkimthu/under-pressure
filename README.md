# under-pressure

Pressure control files for fluctuating experiments in the manuscript titled:

## A distinct growth physiology enhances bacterial growth under rapid nutrient fluctuations

Nguyen et al.



## Acknowledgements

This system and code would not exist without the wondrous Vicente Fernandez.



## WORKFLOW: automated control of Microfluidic Signal Generator

The following scripts were used to calibrate and operate a custom built pressure regulation system, which generated controlled fluctuations in nutrient concentration to cells within a microfluidic device.

Signals fluctuated between two media inputs: a high and a low nutrient concentration. The pressure within each input (see Fig. 1 and Supplementary Information of Nguyen et al.) determined which nutrient medium would be experienced by the cells.

### One. calibratePressure.m
Determines which pressures would enable complete switching between high and low inputs. With inputs flowing into the microchannel and the flow channel clear of bubbles, the user can adjust the pressure differential between the two inputs and visually determine whether to increase or decrease this difference via microscopic imaging at the signal junction (Supplementary Fig. 1).

### Two. createSignal.m
Using the pressure differences calibrated from the above script, the user can define:
	Mn = mean flow rate (generally set at 1)
	DiffB = difference for high input to overtake low
	DiffS = difference for low input to overtake high (use absolute value)
	XTime = transition time (leave empty [])
	Period = desired fluctuation T in seconds
	Rate = signal bits per second
The signal generated is a variable that is called when running the next script.

### Three. runPressure.m
Takes the created signal and initiates it upon sensing that image acquisition has begun, thus timing fluctuating signal with experimental t = 0.
	Signal = variable name used when creating signal in above script (SgO)
	FlName = file name of .nd2 file generated upon start of imaging. Matlab will look for this file and initiate 		  daq control of pressure when the file is created ('name', do not include '.nd2')
	MxTime = length of experiment in hours. Signal will repeat until this time is reached.




