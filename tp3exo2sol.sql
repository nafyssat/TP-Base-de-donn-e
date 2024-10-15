CREATE TABLE routes (
    route_id VARCHAR(50) NOT NULL,
    agency_id VARCHAR(50) NOT NULL,
    route_short_name VARCHAR(300),
    route_long_name VARCHAR(300),
    route_desc,
    route_type INTEGER,
    route_url,
    route_color VARCHAR(6),
    route_text_color VARCHAR(6),
    route_sort_order VARCHAR(6)

);

CREATE TABLE trips (
    route_id,
    service_id,
    trip_id,
    trip_headsign,
    trip_short_name,
    direction_id,
    block_id,
    shape_id,
    wheelchair_accessible,
    bikes_allowed
);


