import std.json;
import std.stdio;
import std.file;
import std.string;
import std.random;
import std.conv;
import std.format;



bool isIn(string check, string str)
{
    writeln("checking if is in:");

    writeln(check);
    writeln(str);

    if (check == str)
    {   return true;    }

    return false;
}


void main(string[] args)
{


    //Open a file containing ilst of patiant IDs (else use for loop iterator)
    //Open file with Anthrax Symptoms
    //Open file with other symptoms
    //define json structure

    //Loop for how ever many patiants we asked for


    File JSON;
    File ids;
    File symptoms;
    File ReportMethods;
    File LocationPairs;


    int realstart = 0;
    int realend = 0;
    int fakeend = 0;
    int fakestart = 0;



    if (args.length >= 11)       //Open the files
    {
        JSON = File(args[1], "r");
        ids = File(args[2], "r");
        symptoms = File(args[3], "r");
        realstart = to!int(args[4]);
        realend = to!int(args[5]);
        fakestart =  to!int(args[6]);
        fakeend =  to!int(args[7]);
        ReportMethods =  File(args[8], "r");
        LocationPairs = File(args[9], "r");

    }
    else if (args.length == 2)
    {
        if (args[1] == "help")
        {
            writeln( "JSONFile idsfile symptomsfile [startOfRealSymptoms] [EndOfRealSymptoms] [StartOfFakeSymptoms] [EndOfFakeSymptoms] reportmethods locationpairs [numberOfPatiants]");
            return;
        }

    }
    else
    {
        return ;
    }

    string JSONStructureString = "{    \"patiant_id\": \"\", \"report_method\":\"\", \"report_location\":[],\"Symptoms\":[] }";       //Read in the JSON structure from file
    string JSONStructureFields[10];

    int lineCount = 1;

    while (!JSON.eof())
    {
        JSONStructureFields[lineCount] = JSON.readln();
    }



    //JSONValue j = parseJSON(JSONStructureString);     //Parse the JSON
    JSONValue j = parseJSON(JSONStructureString);
    writefln("Doing %s Patiants", args[]);

    writeln("Using JSON structure: \n");
    writeln(j.toString);

    JSONValue patiants[];    //List of patiants

    patiants.length = to!int(args[10]);


    //Read in all the anthrax symptoms


    //XXX For now we have statically defined limits to how many symptoms there are - We could make this dynamic


    //TODO Put all this inside a function - Its horrible out here!

    string[] symptomsList;
    lineCount = 0;
    while(!symptoms.eof())
    {
        string line = strip (symptoms.readln());
        symptomsList ~= line;
        lineCount++;
    }

    string[] ReportMethodsList;
    lineCount = 0;
    while(!ReportMethods.eof())
    {
        string line = strip (ReportMethods.readln());
        ReportMethodsList ~= line;
        lineCount++;
    }
    writeln(ReportMethodsList);

    JSONValue[] LocationPairsList;
    lineCount = 0;
    while(!LocationPairs.eof())
    {
        string line = strip (LocationPairs.readln());
        LocationPairsList ~= parseJSON(line);
        lineCount++;
    }

    writefln("The asymptoms list is %s long", symptomsList.length);

    writeln(symptomsList);


    //How many symptoms does each patiant have maximum?
    int RealSymptomLim = 4;
    int  OtherSymptomLim = 5;

    int RealSymptomStart = realstart;
    int OtherSymptomStart = realend+1; //HOW MANY REAL ANTHRAX SYMPTOMS HAVE WE GOT?
    //WHAT ABOUT THE DIFFERENT KINDS OF ANTHRAX?????
    //XXX

    string[4] types = ["@","%","$","*"];


    int i = 0;
    while (!ids.eof())  //For every ID
    {
        if (i >= patiants.length)   //Check because EOF doesnt happen until i is already out of range
        { break; }

        patiants[i] = parseJSON(JSONStructureString); //New patiant
        patiants[i].object["patiant_id"] = JSONValue(strip(ids.readln()));
        patiants[i].object["report_method"] = JSONValue(strip(ReportMethodsList[uniform(0,ReportMethodsList.length-1)]));   //Get random report method
        patiants[i].object["report_location"] = JSONValue(LocationPairsList[uniform(0,LocationPairsList.length-1)]);   //Get random report method

        writeln(patiants[i].object["report_method"].toString());

        string RealSymptoms[];
        RealSymptoms.length = RealSymptomLim;

        int noRealSimps = uniform(0, RealSymptomLim);
        int noFakeSimps = uniform(1, OtherSymptomLim);

        writeln("real symps:");
        writeln(noRealSimps);
        writeln("fake symps:");
        writeln(noFakeSimps);

        string type = types[uniform (0, types.length)]; //pick a type of anthrax for this patiant
        string[] choosenSymptomsList;       //The symptoms we've got already, no duplicates!
        string[] choosenFakeSymptomsList;

        writefln("Choose: %s", type);
        writeln(type);

        string symptom = "";
        bool again = false;


        if (noRealSimps > 0)
        {
            for (int k = 0; k < noRealSimps; k++)   //Get real symptoms 0 to max. Will sometimes pick 0
            {
                //make sure that the symptom we pick, conforms with the type we picked earlier.
                while (indexOf(symptom,type) < 0)     //While the first char is not one of the type chars
                {
                    symptom = symptomsList[uniform(0,realend)];

                }

                for(int tick = 0; tick < choosenSymptomsList.length;tick++)
                {
                    writefln("Checking %s against %s", choosenSymptomsList[tick], symptom);
                    if (choosenSymptomsList[tick] ==  symptom)
                    {   
                        symptom = " ";
                        k--;
                        again = true;
                        break;
                    }
                    again = false;
                }
                if (again != true)
                {
                    patiants[i]["Symptoms"].array ~= JSONValue(chompPrefix(symptom, to!string(type)));       //Pick a few real symptoms.
                    choosenSymptomsList ~= symptom;
                    writeln(choosenSymptomsList);
                }
            }



        }

        again = false;
        string FakeSymptoms[];
        FakeSymptoms.length = symptomsList.length;
        for (int f = 0; f < noFakeSimps; f++)   //Get real symptoms 0 to max. Will sometimes pick 0
        {
            writeln("Other symptomstart: ",OtherSymptomStart);
            symptom = symptomsList[uniform(OtherSymptomStart,symptomsList.length)];
            symptom = symptomsList[uniform(OtherSymptomStart,symptomsList.length)];

            for(int tick = 0; tick < choosenFakeSymptomsList.length;tick++)
            {
                writefln("Checking %s against %s", choosenFakeSymptomsList[tick], symptom);
                if (choosenFakeSymptomsList[tick] ==  symptom)
                {   
                    symptom = " ";
                    f--;
                    again = true;
                    break;
                }
                again = false;
            }
            if (again != true)
            { 
                string symptomObject = format("{\"name\": \"%s\"},", chompPrefix(symptom, to!string(type)));
                patiants[i]["Symptoms"].array ~= parseJSON(symptomObject);       //Pick a few real symptoms.
                choosenFakeSymptomsList ~= symptom;
                writeln(choosenFakeSymptomsList);
            }
        }

        i++;
    }


    foreach(int p, JSONValue patiant; patiants)
    {
        string patiantJSON = patiant.toPrettyString();
        append("Patiants.json", patiantJSON);
        append("Patiants.json", "\n");
//        writeln(patiantJSON);
    }

        






}
