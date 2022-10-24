import "replace";
import { format } from "node-pg-format";


// Scripts to format data to be used in the database

export function formatMatrix (_matrix){
    for (let y = 0 ; y < _matrix.length ; y++ ){
        for (let x = 0 ; x < _matrix[y].length ; x++ ){
            console.log(`the value of _matrix[${y}][${x}] is ${_matrix[y][x]}`);
                _matrix[y][x] = _matrix[y][x].replace(/\'/g, "__");
        }
    }
    return _matrix;
}

export function formatField (_field){
    if (_field.length >= 8 && _field.length <= 10 && !_field.includes("INV-")){
        let day = "", month = "", year = "";
        let timeCounter = 0;
        for ( let i = 0 ; i < _field.length ; i++ ){
            if (_field[i] != "/" && timeCounter == 0){
                day += _field[i];
            } else if (_field[i] != "/" && timeCounter == 1){
                month += _field[i];
            } else if (_field[i] != "/" && timeCounter == 2){
                year += _field[i];
            } else {
                timeCounter++;
            }
        }
        return `\'${year}-${month}-${day}\'`;
    } else if (_field.length == 0){
        return null;
    }
    return `\'${_field.replace(/\'/g, "__")}\'`;
}

export function formatTableTitle (_tableTitle){
    return _tableTitle.replace(/\s/g,"").replace(/\"/g,"").replace(/\'/g,"__");
}


