const { Console } = require('console');
const fs = require('fs');

function main () {
    fs.writeFileSync('./build/test.json', `{"Firstname":"Shaun", "Lastname":"Soria"}`);

    const test = require('./../build/test.json');

    const testP = JSON.parse(JSON.stringify(test));

    testP.Firstname = "Test Shaun";
    testP.Lastname = "Test Soria";
    testP.array = [];
    testP.array.push({name:"Jimmy", role: "graphics designer"});

    console.log(`This is testP.Firstname: ${testP.Firstname} and testP.Lastname: ${testP.Lastname}`);

    fs.writeFileSync('./build/test.json',  `${JSON.stringify(testP,null,2)}`);

}



main ();
