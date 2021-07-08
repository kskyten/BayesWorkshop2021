using Feather
using RData
using HTTP
using FileIO
using Dates

const PEST_DATA = "https://github.com/jgabry/stancon2018helsinki_intro/raw/master/data/pest_data.RDS"

function stream(url)
    HTTP.open("GET", url) do http
        load(Stream(format"RDataSingle", http))
    end
end

function fetch(url)
    HTTP.open("GET", url) do http
        open("pest_data.rds", "w") do f
            write(f, http)
        end
    end
end

function tojulia()
    pest_data = load("pest_data.rds")
    pest_data.date = convert.(Date, pest_data.date)
    pest_data.floors = convert.(Int, pest_data.floors)
    pest_data.age_of_building = convert.(Int, pest_data.age_of_building)
    pest_data.month = convert.(Int, pest_data.month)
    pest_data.traps = convert.(Int, pest_data.traps)
    pest_data.complaints = convert.(Int, pest_data.complaints)
    pest_data.live_in_super = convert.(Bool, pest_data.live_in_super)
    Feather.write("pest_data.feather", pest_data)
end
