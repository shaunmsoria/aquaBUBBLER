import "csv";
import * as fs from "fs";
import { mainT } from "./postgres.js";



function csvReader(){
    let matrixT;
    const data = fs.readFileSync('./data/testDatabase.csv', {encoding:'utf8', flag:'r'});
    matrixT = data.split(/\r\n/g);
    for ( let i = 0; i < matrixT.length; i++){
        matrixT[i] = matrixT[i].split(",");
    };
    return matrixT;
};

const main = async () => {
    
    let matrix = csvReader();

    mainT(matrix);

};

main();