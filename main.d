import std.stdio, std.array, std.algorithm, std.conv, std.format, std.json, std.math, std.file;
class Station {
    private:
        double minimum;
        double maximum;
        double total;
        int count;

    this(double temperature){
        minimum = temperature;
        maximum = temperature;
        total = temperature;
        count = 1;
    }

    void add(double temperature){
        this.minimum = min(temperature, minimum);
        this.maximum = max(temperature, maximum);
        this.total += temperature;
        this.count++;
    }

    public override string toString(){
        return format("%s/%s/%s",this.minimum,round((this.total/this.count)*10)/10,this.maximum);
    }


}

bool contains(Station[char[]] array, string key){
    return (key in array) != null;
}

void processLine(string line){
    string[] split = line.split(";");
    string station = split[0];
    double temperature = to!double(split[1]);

    if(contains(stations, station)){
        stations[station].add(temperature);
    } else {
        stations[station] = new Station(temperature);
    }
}

Station[char[]] stations;

int main(char[][] args)
{   
    if(args.length != 2 || !args[1].exists){
        writeln("Error: This program requires the name of the selected measurements file. It was either not found or no argument was provided.");
        return 1;
    }

    stations = new Station[char[]];

    auto file = File(args[1],"r");
    auto range = file.byLineCopy();

    foreach (line; range)
    {
        processLine(line);
    }

    file.close();

    string output = "{";

    foreach(key; stations.keys.sort){ 
        output ~= format("%s=%s, ",key,stations[key]);
    }
    output = output[0..$-2]~"}";

    File outputFile = File("result.txt", "w");
    outputFile.write(output);
    outputFile.close();

    return 0;
}
