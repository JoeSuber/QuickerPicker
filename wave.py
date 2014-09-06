import numpy as np
"""
output a list of points consumable by openscad polygon function
"""

def wave(degs, scale=10):
    pts = []
    for i in xrange(degs):
        rad = i*np.pi/180.0
        x = float(i/180.0*scale)
        y=np.sin(rad) * scale
        pts.append([x, y])
    return pts

def pwave(degs, scale=20):
    # default scale of 20 would give: 0 < x < 40 units
    print("points = {};".format(wave(degs, scale=scale)))
    print("*** finito ***")
    return 0

if __name__ == "__main__":
    pwave(359, scale=100)

