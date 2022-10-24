const path = require("path");
const fs = require("fs");
const canva = require("canvas");

console.log(`Hello world!`);

async function drawImg (_i){
    const canvas = canva.createCanvas(540,540);
    const ctx = canvas.getContext("2d");


    await canva.loadImage("./artwork/Background/purB.png").then((image)=>{
        ctx.drawImage(image,0,0,540,540);
        const buffer = canvas.toBuffer("image/png");
        fs.writeFileSync(`./images/test${_i}.png`, buffer);
        console.log(`After creating image ${_i}`);
    })

};

async function main(){
    for(let i = 0; i < 10; i++){
        console.log(`Before creating image${i}`);
        await drawImg(i);
    }
    
};

main ();