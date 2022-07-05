
-- name - 492 records match
select
    ofac.id as ofac_id,
    gbr.id as gbr_id,
    "name match" as reason
from ofac
join gbr
    on ofac.name = gbr.name

-- addresses
-- id numbers
-- aliases
-- position?
-- date of birth?
