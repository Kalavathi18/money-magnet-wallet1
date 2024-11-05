var colors=['red','yellow','orange','green','blue','voilet','pink'];
var len=colors.length-1;

var btnControl=document.getElementById("btn");
var spanControl=document.querySelector(".bgcolor");

btnControl.addEventListener('click',()=>{
    var index=generateRandomColor();
    document.body.style.backgroundColor=colors[index];
    spanControl.textContent=colors[index];
})

function generateRandomColor(){
    return Math.round(Math.random()*len);
}