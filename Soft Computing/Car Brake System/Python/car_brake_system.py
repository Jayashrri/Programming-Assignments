import numpy as np
import skfuzzy as fuzzy
import csv

from matplotlib import pyplot as plt

# Fetching Inputs
DISTANCE = float(input("Distance [0 - 10 m]: "))
SPEED = float(input("Speed [0 - 120 kmph]: "))
ANGLE = float(input("Angle [-60 - 60 deg]: "))
IRI = float(input("IRI [0 - 9 m/km]: "))

# Validating Inputs
try:
    if DISTANCE < 0 or DISTANCE > 10:
        raise ValueError("Distance out of range")
    if SPEED < 0 or SPEED > 120:
        raise ValueError("Distance out of range")
    if ANGLE < -60 or ANGLE > 60:
        raise ValueError("Angle out of range")
    if IRI < 0 or IRI > 9:
        raise ValueError("IRI out of range")
except TypeError as err:
    print(err)

# FLC   
x_distance = np.arange(0,10.01,0.01)
x_speed = np.arange(0,120.01,0.01)
x_angle = np.arange(-60,60.01,0.01)
x_iri = np.arange(0,9.01,0.01)

x_brake = np.arange(0,10.01,0.01)

distance_near = fuzzy.trapmf(x_distance, [0, 0, 2, 3])
distance_medium = fuzzy.trimf(x_distance, [2, 4, 5])
distance_far = fuzzy.trapmf(x_distance, [4, 7, 10, 10])

speed_slow = fuzzy.trapmf(x_speed, [0, 0, 30, 50])
speed_medium = fuzzy.trimf(x_speed, [40, 60, 80])
speed_fast = fuzzy.trapmf(x_speed, [70, 90, 120, 120])

angle_down = fuzzy.trapmf(x_angle, [-60, -60, -40, -20])
angle_straight = fuzzy.trimf(x_angle, [-30, 0, 30])
angle_up = fuzzy.trapmf(x_angle, [20, 40, 60, 60])

iri_smooth = fuzzy.trapmf(x_iri, [0, 0, 3, 5])
iri_rough = fuzzy.trapmf(x_iri, [4, 6, 10, 10])

brake_weak = fuzzy.trapmf(x_brake, [0, 0, 3, 4])
brake_medium = fuzzy.trapmf(x_brake, [3, 4, 6, 7])
brake_strong = fuzzy.trapmf(x_brake, [6, 7, 10, 10])

plt.xlabel("Distance (m)")
plt.plot(x_distance, distance_near, label="Near")
plt.plot(x_distance, distance_medium, label="Medium")
plt.plot(x_distance, distance_far, label="Far")
plt.legend(loc="best")
plt.show()

plt.xlabel("Speed (km/h)")
plt.plot(x_speed, speed_slow, label="Slow")
plt.plot(x_speed, speed_medium, label="Medium")
plt.plot(x_speed, speed_fast, label="Fast")
plt.legend(loc="best")
plt.show()

plt.xlabel("Angle (degree)")
plt.plot(x_angle, angle_down, label="Down")
plt.plot(x_angle, angle_straight, label="Straight")
plt.plot(x_angle, angle_up, label="Up")
plt.legend(loc="best")
plt.show()

plt.xlabel("IRI (m/km)")
plt.plot(x_iri, iri_smooth, label="Smooth")
plt.plot(x_iri, iri_rough, label="Rough")
plt.legend(loc="best")
plt.show()

plt.xlabel("Brake Intensity")
plt.plot(x_brake, brake_weak, label="Weak")
plt.plot(x_brake, brake_medium, label="Medium")
plt.plot(x_brake, brake_strong, label="Strong")
plt.legend(loc="best")
plt.show()


distance_near_level = fuzzy.interp_membership(x_distance, distance_near, DISTANCE)
distance_medium_level = fuzzy.interp_membership(x_distance, distance_medium, DISTANCE)
distance_far_level = fuzzy.interp_membership(x_distance, distance_far, DISTANCE)

speed_slow_level = fuzzy.interp_membership(x_speed, speed_slow, SPEED)
speed_medium_level = fuzzy.interp_membership(x_speed, speed_medium, SPEED)
speed_fast_level = fuzzy.interp_membership(x_speed, speed_fast, SPEED)

angle_down_level = fuzzy.interp_membership(x_angle, angle_down, ANGLE)
angle_straight_level = fuzzy.interp_membership(x_angle, angle_straight, ANGLE)
angle_up_level = fuzzy.interp_membership(x_angle, angle_up, ANGLE)

iri_smooth_level = fuzzy.interp_membership(x_iri, iri_smooth, IRI)
iri_rough_level = fuzzy.interp_membership(x_iri, iri_rough, IRI)


active_rules = {
    "WEAK": None,
    "MEDIUM": None,
    "STRONG": None
}

with open('../FuzzyRuleBase.csv') as ruleBaseFile:
    ruleBase = csv.reader(ruleBaseFile, delimiter=',')
    line = 0

    for row in ruleBase:
        if line != 0:
            iri = iri_smooth_level if row[0] == 'SMOOTH' else iri_rough_level
            speed = speed_slow_level if row[1] == 'SLOW' else speed_medium_level if row[1] == 'MEDIUM' else speed_fast_level
            distance = distance_near_level if row[2] == 'NEAR' else distance_medium_level if row[2] == 'MEDIUM' else distance_far_level
            angle = angle_down_level if row[3] == 'DOWN' else angle_straight_level if row[3] == 'STRAIGHT' else angle_up_level

            active_rule = np.fmin(iri, np.fmin(speed, np.fmin(distance, angle)))
            if active_rules[row[4]] == None:
                active_rules[row[4]] = active_rule
            else:
                active_rules[row[4]] = np.fmax(active_rules[row[4]], active_rule)
        line += 1


brake_weak_activation = np.fmin(active_rules['WEAK'], brake_weak)
brake_medium_activation = np.fmin(active_rules['MEDIUM'], brake_medium)
brake_strong_activation = np.fmin(active_rules['STRONG'], brake_strong)

aggregate = np.fmax(brake_weak_activation, np.fmax(brake_medium_activation, brake_strong_activation))

brake_result = fuzzy.defuzz(x_brake, aggregate, 'centroid')
print("\nBrake Result: " + str(brake_result))