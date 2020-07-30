var a = [10,9,8,7,6,5,4,3,2,1];
var bubble_counter = 0;
function fill(arr)
{
    for (var i = 0; i < arr.length; i++)
    {
        var s = (i+1).toString();
        document.getElementById(s).innerHTML = arr[i];
    }
}
fill(a);

function random()
{
    a = Array.from({length: 10}, () => Math.floor(Math.random() * 100));
    fill(a);
}

function reset()
{
    a = [10,9,8,7,6,5,4,3,2,1];
    fill(a);
    document.getElementById("bubble result").innerHTML = 0;
}


function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function clear()
{
    for (var n = 0; n < 10; n++)
    {
        var s = (n+1).toString();
        document.getElementById(s).style.backgroundColor = 'white';
    }
}

function highlight(i)
{
    clear();
    var s1 = (i+1).toString();
    var s2 = (i+2).toString();
    document.getElementById(s1)['className'] ='table-primary';
    //document.getElementById(s2).style.backgroundColor = 'blue';

}


async function bubble_Sort_Visual(arr)
{
    var unsorted = true;
    bubble_counter = 0;
    var size = arr.length - 1;
    var result = arr;
    do
    {
        unsorted = false;
        for (var i=0; i < size; i++)
        {
                await sleep(500);
                highlight(i);
                if (result[i] > result[i+1])
                {
                    var tmp = result[i];
                    result[i] = result[i+1];
                    result[i+1] = tmp;
                    fill(result);
                    unsorted = true;
                    bubble_counter += 1;
                    document.getElementById("bubble result").innerHTML = bubble_counter;
                }

        }
        size--;
        clear();

    }
    while (unsorted);
    a = result;
    return a;
}