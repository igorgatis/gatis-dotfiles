#!/bin/env python3

import math
import sys
import re
import json


def new_feature(properties, geo_type, coords_list):
    return {
        "type": "Feature",
        "properties": properties,
        "geometry": {
            "type": geo_type,
            "coordinates": coords_list,
        }
    }


def distance_in_km(lat1, lng1, lat2, lng2) -> float:
    lat1, lng1, lat2, lng2 = map(math.radians, [lat1, lng1, lat2, lng2])
    # Haversine formula (https://en.wikipedia.org/wiki/Haversine_formula)
    dlat = lat2 - lat1
    dlng = lng2 - lng1
    hav_lat = math.sin(dlat / 2) ** 2
    hav_lon = math.cos(lat1) * math.cos(lat2) * math.sin(dlng / 2) ** 2
    haversine = hav_lat + hav_lon
    central_angle = 2 * \
        math.atan2(math.sqrt(haversine), math.sqrt(1 - haversine))
    earth_radius_in_km = 6371.0
    return earth_radius_in_km * central_angle


_PARSE_ANGLE = re.compile(r"(-?\d+\.\d+)")


def main():
    while True:
        parts = []
        while line:= sys.stdin.readline():
            parts.extend(_PARSE_ANGLE.findall(line))
            if len(parts) == 4:
                break

        lat1, lng1, lat2, lng2 = map(float, parts)
        dist_in_km = distance_in_km(lat1, lng1, lat2, lng2)

        dist_text = f"{dist_in_km:.3f}km"
        if dist_in_km < 0.5:
            dist_text = f"{(dist_in_km*1000):.1f}m"
        feature = new_feature(
            {"Distance": dist_text},
            "LineString",
            [[lng1, lat1], [lng2, lat2]])
        print(json.dumps(feature))


if __name__ == "__main__":
    main()
