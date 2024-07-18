#!/bin/env python3

import json
import sys


def new_feature(properties, geo_type, coords_list):
    return {
        "type": "Feature",
        "properties": properties,
        "geometry": {
            "type": geo_type,
            "coordinates": coords_list,
        }
    }


def main():
    data = json.load(sys.stdin)
    features_list = []

    for result in data.get("results", []):
        properties = {
            "formatted_address": result.get("formatted_address"),
            "partial_match": result.get("partial_match"),
            "types": ",".join(result.get("types", [])),
        }
        for component in result.get("address_components", []):
            type = [t for t in component["types"] if t != "political"][0]
            properties[type] = component["long_name"]
        geometry = result.get("geometry")
        if geometry:
            location = geometry.get("location")
            properties["location_type"] = geometry["location_type"]
            if location:
                features_list.append(new_feature(
                    properties, "Point", [location["lng"], location["lat"]]))
            viewport = geometry.get("viewport")
            if viewport:
                sw = viewport["southwest"]
                ne = viewport["northeast"]
                polygon = [[
                    [sw.get("lng"), sw.get("lat")],
                    [ne.get("lng"), sw.get("lat")],
                    [ne.get("lng"), ne.get("lat")],
                    [sw.get("lng"), ne.get("lat")],
                    [sw.get("lng"), sw.get("lat")],
                ]]
                features_list.append(new_feature(
                    properties, "Polygon", polygon))
    features = {
        "type": "FeatureCollection",
        "features": features_list,
    }
    print(json.dumps(features))

if __name__ == "__main__":
    main()