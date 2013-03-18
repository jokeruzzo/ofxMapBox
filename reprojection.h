/* reprojection.h
*
* Convert OSM lattitude / longitude from degrees to mercator
* so that Mapnik does not have to project the data again
*
*/

#ifndef REPROJECTION_H
#define REPROJECTION_H

#import "proj_api.h"
#define PROJ_LATLONG 1
#define PROJ_MERC 2
#define PROJ_SPHERE_MERC 3
#define PROJ_COUNT 3

struct Projection_Info {
    char *descr;
    char *proj4text;
    int srs;
    char *option;
};

extern const struct Projection_Info Projection_Info[];


class Projection{
public:
void project_init(int);
void project_exit(void);
struct Projection_Info const* project_getprojinfo(void);
void reproject(double *lat, double *lon);
void coords_to_tile(double *tilex, double *tiley, double lon, double lat);

    /** The projection of the source data. Always lat/lon (EPSG:4326). */
    projPJ pj_source = NULL;
    /** The target projection (used in the PostGIS tables). Controlled by the -l/-M/-m/-E options. */
    projPJ pj_target = NULL;
    /** The projection used for tiles. Currently this is fixed to be Spherical
     *  Mercator. You will usually have tiles in the same projection as used
     *  for PostGIS, but it is theoretically possible to have your PostGIS data
     *  in, say, lat/lon but still create tiles in Spherical Mercator.
     */
    projPJ pj_tile = NULL;
};
#endif