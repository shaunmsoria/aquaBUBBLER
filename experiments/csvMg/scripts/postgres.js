import * as dotenv from "dotenv";
    dotenv.config();
import {
    formatMatrix,
    formatField,
    formatTableTitle
} from "./format.js";
import pkgpg from "pg";
    const { Client } = pkgpg;
import "replace";
import { format } from "node-pg-format";



function cQuery (_command){
    client
        .query(_command)
        .then(res => { console.log(res.rows) })
        .catch(e => console.error(e.stack))
};

function cMatrixInsert (_Matrix){
    for ( let y = 1 ; y < _Matrix.length ; y++){
        let xString = ``;
        for ( let x = 0 ; x < _Matrix[y].length ; x++ ){
            console.log(`The value of _Matrix[${y}][${x}] is ${_Matrix[y][x]}`);
            ( x == _Matrix[y].length - 1 ? xString += `${formatField(_Matrix[y][x])}` : xString += `${formatField(_Matrix[y][x])},`);
        }
        console.log(`The value of _Matrix[${y}] is ${xString}`);
        client
        .query(`INSERT INTO opsreport (customerOrderId,type,quantity,name,poreceived,sale,pcfreceived,inputpcfinlucille,new,scheduled,inprogress,boxing,unitconstructed,labelprinting,dispatched,invoicing,invoicedate) VALUES (${xString});`)
        .then(res => { console.log(res.rows) })
        .catch(e => console.error(e.stack))
    }
}

function cTableInsert (tableName, tableMatrix){
    let tableTitle = ``;
    for ( let titleIndex = 0 ; titleIndex < tableMatrix[0].length ; titleIndex++ ){
        if ( !tableMatrix[0][titleIndex] || tableMatrix[0][titleIndex].length === 0 ){
            continue;
        }
        ( !tableMatrix[0][titleIndex + 1 ] || tableMatrix[0][titleIndex + 1 ].length === 0   ? tableTitle += `${formatTableTitle(tableMatrix[0][titleIndex])}` : tableTitle += `${formatTableTitle(tableMatrix[0][titleIndex])},` );
        console.log(`The value of tableMatrix[${0}][${titleIndex}] is ${tableMatrix[0][titleIndex]}`);
        console.log(`The value of tableTitle is ${tableTitle}`);
    }
    for ( let y = 1 ; y < tableMatrix.length ; y++){
        let xString = ``;
        for ( let x = 0 ; x < tableMatrix[y].length ; x++ ){
            console.log(`The value of tableMatrix[${y}][${x}] is ${tableMatrix[y][x]}`);
            ( x == tableMatrix[y].length - 1 ? xString += `${formatField(tableMatrix[y][x])}` : xString += `${formatField(tableMatrix[y][x])},`);
        }
        console.log(`The value of tableTitle after building is ${tableTitle}`);
        console.log(`The value of _Matrix[${y}] is ${xString}`);
        client
            .query(`INSERT INTO ${tableName} (${tableTitle}) VALUES (${xString});`)
            // .query(`INSERT INTO ${tableName} VALUES (${xString});`)
            // .query(`INSERT INTO opsreport (customerOrderId,type,quantity,name,poreceived,sale,pcfreceived,inputpcfinlucille,new,scheduled,inprogress,boxing,unitconstructed,labelprinting,dispatched,invoicing,invoicedate) VALUES (${xString});`)
            .then(res => { console.log(res.rows) })
            .catch(e => console.error(e.stack))
    }
}

function cDataInsert (tableName, tableContent) {
    // scope: check if table already Exists, if not call cCreateTable/cTableInsert, if yes call cTableInsert


}

const createT = `
    CREATE TABLE test (
        user_id serial PRIMARY KEY,
        name VARCHAR ( 50 ),
        password VARCHAR ( 50 ),
        email VARCHAR ( 255 )
    );`

function cCreateTable (tableName, tableContent) {
    // requirement: tablename does not exists
    // scope: create new table in DB
    let tableMetaData = `CREATE TABLE ${tableName} (id serial PRIMARY KEY`;
    if ( tableContent[0].length = 0) {
        throw `can not create an empty table`;
    } else {
        for ( let x = 0 ; x < tableContent[0].length ; x++ ){
            tableContent[0][x] = formatTableTitle(tableContent[0][x]);
        }
        for (let x = 0 ; x < tableContent[0].length ; x++ ){
            if ( !tableContent[ 0 ][ x ] || tableContent[ 0 ][ x ].length === 0 ){
                tableMetaData += `, undefined${x} VARCHAR`;
                console.log(`the value of tableMetaData is ${tableMetaData}`);
            } else {
                tableMetaData += `, ${tableContent[0][x]} VARCHAR`;
                console.log(`the value of tableMetaData is ${tableMetaData}`);
            }
            if ( !tableContent[ 0 ][ x + 1 ] || tableContent[ 0 ][ x + 1 ].length === 0 ){
                tableMetaData += `);`;
                console.log(`the value of tableMetaData is ${tableMetaData}`);
            }
        };
    }
    cQuery(tableMetaData);
}


function cEnd(){
    client
        .query(`DROP TABLE IF EXISTS pO$3kJtR913`)
        .then(res => { console.log("connection ended") })
        .catch(e => console.error(e.stack))
        .then(() => client.end());
};

const client = new Client({
    user: process.env.user,
    host: process.env.host,
    database: process.env.database,
    password: process.env.password,
    port: process.env.port
});



export async function mainT (_Matrix){
    // console.log(`test show in mainT`);
    client.connect();
    const lineT = `INSERT INTO accounts (username, password, email, created_on) VALUES($1, $2, $3, $4)`;
    const dropT = `DROP TABLE accounts`;
        


    
    const createTableMeta4 = `
        CREATE TABLE OpsReport (
            orderId serial PRIMARY KEY,
            customerOrderId VARCHAR ( 50 ),
            type VARCHAR ( 255 ),
            quantity INT NOT NULL,
            name VARCHAR ( 255 ),
            poReceived DATE,
            sale DATE,
            pcfReceived DATE,
            inputPCFInLucille DATE,
            New DATE,
            scheduled DATE,
            inProgress DATE,
            boxing DATE,
            unitConstructed DATE,
            labelPrinting DATE,
            dispatched DATE,
            invoicing VARCHAR ( 50 ),
            invoiceDate DATE
        );`
    
    const createTableMeta5 = `
        CREATE TABLE testDatabase (
            id serial PRIMARY KEY,
            pcfdate DATE,
            design VARCHAR ( 255 ),
            name VARCHAR ( 255 )
        )
    `

    const roleT = `CREATE ROLE admin2 WITH SUPERUSER LOGIN`;
    const dBT = `CREATE DATABASE operations OWNER admin `;
    const cUserT = `CREATE USER shaun WITH PASSWORD Temp1234`;
    const queryT = {
        name: 'create-user',
        text: 'CREATE USER shaun WITH PASSWORD pw(data)',
        values: ['Temp1234']
    }
    const uID = process.env.uID;
    // const altT = format(`SELECT * FROM test WHERE user_id = %L`, uID);

    
    
    cQuery(`DROP TABLE IF EXISTS testDatabase;`);

    cCreateTable(`testDatabase`,_Matrix);

    // cQuery(createTableMeta5);
    // cTableInsert("testDatabase",_Matrix);

    // cQuery(`SELECT EXISTS ( SELECT FROM pg_tables WHERE tablename = 'opsreport')`);

    // cMatrixInsert(_Matrix);


    cEnd();

};

