// unit sine-wave 0-359 deg for doing projections onto other solids
// below python code used to print points list:

/*
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
    print("sinepoints = {};".format(wave(degs, scale=scale)))
    print("*** finito ***")
    return 0

if __name__ == "__main__":
    pwave(359, scale=100)
*/


sinepoints = [[0.0, 0.0], [0.11111111111111112, 0.34904812874567026], [0.22222222222222224, 0.69798993405001941], [0.3333333333333333, 1.0467191248588765], [0.4444444444444445, 1.395129474882506], [0.5555555555555556, 1.7431148549531632], [0.6666666666666666, 2.0905692653530692], [0.7777777777777778, 2.4373868681029496], [0.888888888888889, 2.7834620192013086], [1.0, 3.1286893008046173], [1.1111111111111112, 3.4729635533386065], [1.222222222222222, 3.8161799075308962], [1.3333333333333333, 4.1582338163551862], [1.4444444444444442, 4.4990210868773], [1.5555555555555556, 4.8384379119933545], [1.6666666666666665, 5.1763809020504148], [1.777777777777778, 5.512747116339983], [1.8888888888888888, 5.8474340944547354], [2.0, 6.1803398874989481], [2.111111111111111, 6.5113630891431331], [2.2222222222222223, 6.840402866513374], [2.3333333333333335, 7.1673589909060054], [2.444444444444444, 7.4921318683182401], [2.5555555555555554, 7.8146225697854739], [2.6666666666666665, 8.1347328615160031], [2.7777777777777777, 8.452365234813989], [2.8888888888888884, 8.7674229357815481], [3.0, 9.079809994790935], [3.111111111111111, 9.3894312557178168], [3.2222222222222223, 9.6961924049267409], [3.333333333333333, 9.9999999999999982], [3.4444444444444446, 10.300761498201084], [3.555555555555556, 10.598385284664097], [3.6666666666666665, 10.892780700300541], [3.7777777777777777, 11.183858069414939], [3.888888888888889, 11.471528727020921], [4.0, 11.755705045849464], [4.111111111111111, 12.036300463040966], [4.222222222222222, 12.313229506513164], [4.333333333333334, 12.586407820996747], [4.444444444444445, 12.855752193730785], [4.555555555555555, 13.121180579810144], [4.666666666666667, 13.382612127177165], [4.777777777777778, 13.63996720124997], [4.888888888888888, 13.893167409179945], [5.0, 14.142135623730949], [5.111111111111111, 14.386796006773022], [5.222222222222222, 14.627074032383408], [5.333333333333333, 14.862896509547882], [5.444444444444444, 15.094191604455441], [5.555555555555555, 15.32088886237956], [5.666666666666666, 15.542919229139416], [5.777777777777777, 15.760215072134439], [5.888888888888889, 15.972710200945857], [6.0, 16.180339887498949], [6.111111111111112, 16.383040885779835], [6.222222222222222, 16.580751451100834], [6.333333333333333, 16.773411358908479], [6.444444444444445, 16.960961923128519], [6.555555555555555, 17.143346014042244], [6.666666666666666, 17.320508075688771], [6.777777777777779, 17.492394142787916], [6.888888888888889, 17.658951857178536], [7.0, 17.820130483767358], [7.111111111111112, 17.97588092598334], [7.222222222222222, 18.126155740732997], [7.333333333333333, 18.270909152852017], [7.444444444444445, 18.410097069048806], [7.555555555555555, 18.543677091335748], [7.666666666666667, 18.671608529944034], [7.777777777777778, 18.793852415718167], [7.888888888888888, 18.910371511986334], [8.0, 19.021130325903069], [8.11111111111111, 19.126095119260707], [8.222222222222221, 19.225233918766378], [8.333333333333334, 19.318516525781366], [8.444444444444445, 19.405914525519929], [8.555555555555555, 19.487401295704704], [8.666666666666668, 19.56295201467611], [8.777777777777779, 19.632543668953279], [8.88888888888889, 19.696155060244159], [9.0, 19.753766811902757], [9.11111111111111, 19.805361374831406], [9.222222222222223, 19.85092303282644], [9.333333333333334, 19.890437907365467], [9.444444444444445, 19.92389396183491], [9.555555555555555, 19.951281005196485], [9.666666666666666, 19.972590695091476], [9.777777777777777, 19.987816540381914], [9.88888888888889, 19.996953903127825], [10.0, 20.0], [10.11111111111111, 19.996953903127825], [10.222222222222221, 19.987816540381914], [10.333333333333334, 19.972590695091476], [10.444444444444445, 19.951281005196485], [10.555555555555555, 19.92389396183491], [10.666666666666666, 19.890437907365467], [10.777777777777777, 19.850923032826444], [10.888888888888888, 19.805361374831406], [11.0, 19.753766811902754], [11.11111111111111, 19.696155060244159], [11.222222222222221, 19.632543668953279], [11.333333333333332, 19.562952014676114], [11.444444444444443, 19.487401295704704], [11.555555555555554, 19.405914525519929], [11.666666666666668, 19.318516525781366], [11.777777777777779, 19.225233918766378], [11.88888888888889, 19.126095119260711], [12.0, 19.021130325903073], [12.11111111111111, 18.910371511986337], [12.222222222222223, 18.79385241571817], [12.333333333333334, 18.671608529944034], [12.444444444444445, 18.543677091335748], [12.555555555555555, 18.410097069048806], [12.666666666666666, 18.27090915285202], [12.777777777777777, 18.126155740733001], [12.88888888888889, 17.97588092598334], [13.0, 17.820130483767358], [13.11111111111111, 17.658951857178543], [13.222222222222221, 17.492394142787916], [13.333333333333332, 17.320508075688775], [13.444444444444446, 17.143346014042248], [13.555555555555557, 16.960961923128522], [13.666666666666668, 16.773411358908479], [13.777777777777779, 16.580751451100834], [13.88888888888889, 16.383040885779842], [14.0, 16.180339887498949], [14.111111111111112, 15.972710200945855], [14.222222222222223, 15.760215072134439], [14.333333333333334, 15.54291922913942], [14.444444444444445, 15.32088886237956], [14.555555555555555, 15.094191604455435], [14.666666666666666, 14.862896509547884], [14.777777777777779, 14.627074032383412], [14.88888888888889, 14.386796006773029], [15.0, 14.142135623730951], [15.11111111111111, 13.893167409179943], [15.222222222222221, 13.639967201249972], [15.333333333333334, 13.382612127177167], [15.444444444444445, 13.121180579810146], [15.555555555555555, 12.85575219373079], [15.666666666666666, 12.586407820996754], [15.777777777777777, 12.313229506513167], [15.888888888888888, 12.036300463040963], [16.0, 11.755705045849465], [16.11111111111111, 11.471528727020928], [16.22222222222222, 11.183858069414939], [16.333333333333332, 10.892780700300539], [16.444444444444443, 10.598385284664097], [16.555555555555554, 10.300761498201087], [16.666666666666668, 9.9999999999999982], [16.77777777777778, 9.6961924049267427], [16.88888888888889, 9.3894312557178221], [17.0, 9.0798099947909368], [17.11111111111111, 8.7674229357815463], [17.22222222222222, 8.452365234813989], [17.333333333333336, 8.1347328615160084], [17.444444444444443, 7.8146225697854828], [17.555555555555557, 7.4921318683182445], [17.666666666666664, 7.1673589909060045], [17.77777777777778, 6.8404028665133776], [17.88888888888889, 6.5113630891431402], [18.0, 6.1803398874989499], [18.11111111111111, 5.8474340944547407], [18.22222222222222, 5.5127471163399928], [18.333333333333332, 5.1763809020504201], [18.444444444444446, 4.8384379119933545], [18.555555555555557, 4.4990210868772955], [18.666666666666668, 4.1582338163551862], [18.77777777777778, 3.8161799075308993], [18.88888888888889, 3.4729635533386056], [19.0, 3.1286893008046195], [19.11111111111111, 2.7834620192013149], [19.22222222222222, 2.4373868681029509], [19.333333333333332, 2.0905692653530745], [19.444444444444443, 1.7431148549531728], [19.555555555555554, 1.3951294748825105], [19.666666666666664, 1.0467191248588761], [19.77777777777778, 0.69798993405001397], [19.88888888888889, 0.34904812874566876], [20.0, 2.4492935982947065e-15], [20.11111111111111, -0.34904812874566382], [20.22222222222222, -0.69798993405001797], [20.333333333333332, -1.0467191248588712], [20.444444444444443, -1.3951294748824967], [20.555555555555554, -1.7431148549531588], [20.666666666666668, -2.0905692653530612], [20.77777777777778, -2.4373868681029549], [20.88888888888889, -2.7834620192013104], [21.0, -3.1286893008046146], [21.11111111111111, -3.4729635533386096], [21.22222222222222, -3.8161799075308944], [21.333333333333332, -4.1582338163551817], [21.444444444444443, -4.4990210868772991], [21.555555555555554, -4.83843791199335], [21.666666666666664, -5.1763809020504068], [21.777777777777775, -5.5127471163399804], [21.888888888888893, -5.8474340944547274], [22.0, -6.1803398874989544], [22.111111111111114, -6.5113630891431349], [22.22222222222222, -6.8404028665133731], [22.333333333333336, -7.1673589909060089], [22.444444444444443, -7.4921318683182401], [22.555555555555557, -7.8146225697854712], [22.666666666666664, -8.1347328615159959], [22.77777777777778, -8.4523652348139855], [22.888888888888886, -8.767422935781541], [23.0, -9.0798099947909243], [23.111111111111107, -9.3894312557178168], [23.222222222222225, -9.6961924049267392], [23.333333333333336, -10.000000000000002], [23.444444444444446, -10.300761498201084], [23.555555555555557, -10.598385284664095], [23.666666666666668, -10.892780700300541], [23.77777777777778, -11.183858069414933], [23.88888888888889, -11.471528727020917], [24.0, -11.75570504584946], [24.11111111111111, -12.036300463040961], [24.22222222222222, -12.313229506513157], [24.333333333333332, -12.586407820996753], [24.444444444444446, -12.855752193730785], [24.555555555555557, -13.121180579810147], [24.666666666666668, -13.382612127177165], [24.77777777777778, -13.639967201249966], [24.88888888888889, -13.893167409179947], [25.0, -14.142135623730949], [25.11111111111111, -14.386796006773018], [25.22222222222222, -14.627074032383403], [25.333333333333332, -14.86289650954788], [25.444444444444443, -15.094191604455434], [25.555555555555554, -15.320888862379558], [25.666666666666668, -15.542919229139422], [25.77777777777778, -15.760215072134443], [25.88888888888889, -15.972710200945857], [26.0, -16.180339887498945], [26.11111111111111, -16.383040885779831], [26.22222222222222, -16.580751451100827], [26.333333333333332, -16.773411358908483], [26.444444444444443, -16.960961923128519], [26.555555555555554, -17.143346014042244], [26.666666666666664, -17.320508075688767], [26.777777777777775, -17.492394142787919], [26.888888888888893, -17.65895185717854], [27.0, -17.820130483767358], [27.111111111111114, -17.975880925983336], [27.22222222222222, -18.126155740732994], [27.333333333333336, -18.27090915285202], [27.444444444444443, -18.410097069048806], [27.555555555555557, -18.543677091335745], [27.666666666666664, -18.671608529944031], [27.77777777777778, -18.793852415718163], [27.888888888888886, -18.910371511986337], [28.0, -19.021130325903069], [28.111111111111107, -19.126095119260707], [28.222222222222225, -19.225233918766381], [28.333333333333336, -19.318516525781366], [28.444444444444446, -19.405914525519929], [28.555555555555557, -19.487401295704704], [28.666666666666668, -19.56295201467611], [28.77777777777778, -19.632543668953279], [28.88888888888889, -19.696155060244159], [29.0, -19.753766811902754], [29.11111111111111, -19.805361374831406], [29.22222222222222, -19.850923032826444], [29.333333333333332, -19.890437907365467], [29.444444444444446, -19.92389396183491], [29.555555555555557, -19.951281005196485], [29.666666666666668, -19.972590695091476], [29.77777777777778, -19.987816540381914], [29.88888888888889, -19.996953903127825], [30.0, -20.0], [30.11111111111111, -19.996953903127825], [30.22222222222222, -19.987816540381914], [30.333333333333332, -19.972590695091476], [30.444444444444443, -19.951281005196485], [30.555555555555554, -19.92389396183491], [30.666666666666668, -19.890437907365467], [30.77777777777778, -19.85092303282644], [30.88888888888889, -19.805361374831406], [31.0, -19.753766811902757], [31.11111111111111, -19.696155060244163], [31.22222222222222, -19.632543668953282], [31.333333333333332, -19.562952014676117], [31.444444444444443, -19.487401295704704], [31.555555555555554, -19.405914525519933], [31.666666666666664, -19.318516525781362], [31.777777777777775, -19.225233918766374], [31.888888888888893, -19.126095119260707], [32.0, -19.021130325903073], [32.111111111111114, -18.910371511986341], [32.22222222222222, -18.79385241571817], [32.333333333333336, -18.671608529944042], [32.44444444444444, -18.543677091335748], [32.55555555555556, -18.41009706904881], [32.666666666666664, -18.270909152852013], [32.77777777777778, -18.126155740732997], [32.888888888888886, -17.97588092598334], [33.0, -17.820130483767358], [33.11111111111111, -17.658951857178543], [33.22222222222222, -17.492394142787923], [33.333333333333336, -17.320508075688771], [33.44444444444444, -17.143346014042248], [33.55555555555556, -16.960961923128522], [33.666666666666664, -16.773411358908486], [33.77777777777778, -16.580751451100841], [33.888888888888886, -16.383040885779835], [34.0, -16.180339887498953], [34.11111111111111, -15.972710200945862], [34.22222222222222, -15.760215072134436], [34.33333333333333, -15.542919229139416], [34.44444444444444, -15.320888862379562], [34.55555555555556, -15.094191604455444], [34.66666666666667, -14.862896509547891], [34.77777777777778, -14.627074032383421], [34.888888888888886, -14.386796006773036], [35.0, -14.142135623730955], [35.111111111111114, -13.893167409179952], [35.22222222222222, -13.639967201249965], [35.33333333333333, -13.382612127177163], [35.44444444444444, -13.121180579810147], [35.55555555555556, -12.855752193730792], [35.66666666666667, -12.586407820996756], [35.77777777777778, -12.313229506513178], [35.88888888888889, -12.036300463040966], [36.0, -11.755705045849467], [36.111111111111114, -11.47152872702093], [36.22222222222222, -11.183858069414947], [36.333333333333336, -10.892780700300539], [36.44444444444444, -10.598385284664115], [36.55555555555556, -10.300761498201091], [36.666666666666664, -10.000000000000009], [36.77777777777778, -9.6961924049267374], [36.88888888888889, -9.3894312557178168], [37.0, -9.0798099947909385], [37.111111111111114, -8.767422935781541], [37.22222222222222, -8.4523652348139997], [37.333333333333336, -8.1347328615160031], [37.44444444444444, -7.8146225697854943], [37.55555555555556, -7.4921318683182472], [37.666666666666664, -7.1673589909060151], [37.77777777777778, -6.8404028665133723], [37.888888888888886, -6.5113630891431509], [38.0, -6.1803398874989526], [38.11111111111111, -5.8474340944547256], [38.22222222222222, -5.5127471163399955], [38.333333333333336, -5.1763809020504139], [38.44444444444444, -4.8384379119933572], [38.55555555555556, -4.4990210868773071], [38.666666666666664, -4.1582338163551977], [38.77777777777778, -3.8161799075308931], [38.888888888888886, -3.4729635533386256], [39.0, -3.1286893008046217], [39.11111111111111, -2.7834620192013175], [39.22222222222222, -2.4373868681029625], [39.33333333333333, -2.0905692653530683], [39.44444444444444, -1.7431148549531663], [39.55555555555556, -1.3951294748824952], [39.66666666666667, -1.0467191248588874], [39.77777777777778, -0.69798993405001641]];

// normto uses maxval of the points included in portion 
module sinewave(portion=359, normto=10){
    part = min(len(sinepoints), portion);
    used_p = [for(i=[0:part]) sinepoints[i]];
    pp = concat(used_p, [[used_p[len(used_p)-1][0], 0]]);
    spot = -max([for(i=pp) i[1]]) / 2;
    echo("max value of:", spot, " moved to x=zero");
    translate([spot, 0,0])
        scale([normto/abs(spot), normto/abs(spot)])
            polygon(points=pp);
}

linear_extrude(convexity=10, height=10){
    sinewave(portion=180);}
