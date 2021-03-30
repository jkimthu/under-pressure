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
1. session (type in verbatim, this is to access data acquisition system)
2. Mn = mean flow rate (generally set at 1, use same value for both calibrations)
3. Dff = difference in pressure (+ shifts balance in one direction, - shifts balance towards the other)

### Two. createSignal.m
The signal generated is a variable that is called when running the next script.
Using the pressure differences calibrated from the above script, the user can define:
1. Mn = mean flow rate (use value determined above)
2. DiffB = difference for high input to overtake low
3. DiffS = difference for low input to overtake high (use absolute value of negative value)
4. XTime = transition time (leave empty [])
5. Period = desired fluctuation T in seconds
6. Rate = signal bits per second


### Three. runPressure.m
Takes the created signal and initiates it upon sensing that image acquisition has begun, thus timing fluctuating signal with experimental t = 0.
1. Signal = variable name used when creating signal in above script (SgO)
2. FlName = file name of .nd2 file generated upon start of imaging. Matlab will look for this filenitiate daq control of pressure when the file is created ('name', do not include '.nd2')
3. MxTime = length of experiment in hours. Signal will repeat until this time is reached.




