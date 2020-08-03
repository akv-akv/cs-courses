var a = []; // Sorted array variable
var speed = 50; // Speed variable in ms. Change to define speed of visualization
var b;
var c;
// Counters
var bubble_counter = 0;
var insertion_counter = 0;
var merge_counter = 0;
var quicksort_counter = 0;
Array.range = (start, end) => Array.from({length: (end - start)}, (v, k) => k + start);

// Set all counters to zero
function reset_counters()
{
    bubble_counter = 0;
    insertion_counter = 0;
    merge_counter = 0;
    quicksort_counter = 0;
}

function update_counters()
{
    document.getElementById("bubble result").innerHTML = bubble_counter;
    document.getElementById("insertion result").innerHTML = insertion_counter;
    document.getElementById("merge result").innerHTML = merge_counter;
    document.getElementById("quicksort result").innerHTML = quicksort_counter;
}

function bubble_update()
{
    document.getElementById("bubble result").innerHTML = bubble_counter;
}

var stop = false; // Stop tracker

// Returns copy of given array
function copy_array(arr)
{
    var result = [];
    for (let i = 0; i< arr.length; i++)
    result[i] = arr[i];
    return result;
}

// Updates page with values from given array
function fill(arr)
{
    for (var i = 0; i < arr.length; i++)
    {
        var s = (i+1).toString();
        document.getElementById(s).innerHTML = arr[i];
    }
}

// Creates an array with random values from 1 to 100, fills page with this data and resets counters
function random()
{
    a = Array.from({length: 10}, () => Math.floor(Math.random() * 100));
    fill(a);
    reset_counters();
    update_counters();
}

function reset()
{
    a = [10,9,8,7,6,5,4,3,2,1];
    fill(a);
    reset_counters();
    update_counters();
}


function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function clear()
{
    for (var n = 0; n < 10; n++)
    {
        var s = (n+1).toString();
        let cell = document.getElementById(s);
        cell.className = 'table-default';
    }
}

// Highlighting cells in array with color (red, green or blue)
function highlight(arr, color)
{
    var test = "";
    clear();
    var cell;
    // Switching color parameters and choose corresponding style from Bootstrap
    switch (color)
    {
        case "red":
            test = 'table-danger';
            break;
        case "green":
            test = 'table-success';
            break;
        case "blue":
            test = 'table-primary';
            break;
    }
    // Iterate elements in array and set for them proper class
    for (var i = 0; i<arr.length;i++)
    {
        let s = (arr[i]+1).toString();
        cell = document.getElementById(s);
        cell.className = test;
    }
}

function swap(arr, n1, n2)
{
    var tmp = arr[n1];
    arr[n1] = arr[n2];
    arr[n2] = tmp;
}



async function bubble_Sort_Visual(arr)
{
    stop = false; // Stop tracker, is set true stop iterations through sorted array
    reset_counters(); // Reset counters
    update_counters(); // Update value on page
    var unsorted = true;
    var size = arr.length - 1;
    var result = copy_array(arr);
    do
    {
        unsorted = false;
        for (var i=0; i < size; i++)
        {
                highlight([i, i+1],"blue"); // Highlight with blue cells that are being compared
                await sleep(speed*5);
                if (result[i] > result[i+1])
                {
                    highlight([i, i+1],"red"); // Highlight with red cells if value of first is more than second
                    await sleep(speed*3);
                    swap(result, i, i+1); // Swap cells
                    fill(result);
                    unsorted = true;
                    bubble_counter += 1;
                    bubble_update();
                }
                else
                {
                    highlight([i, i+1],"green");
                    await sleep(speed * 3);
                }
        if (stop) {break;}
        }
        size--;
        clear();
        if (stop) {break;}
    }
    while (unsorted);
    c1 = copy_array(arr);
    c2 = copy_array(arr);
    c3 = copy_array(arr);
    insertion_Sort(c1);
    merge_counter = 0;
    b = merge_Sort(c2);
    c = quick_Sort(c3,0, c3.length-1);
    a = copy_array(result);
    update_counters();
}

function bubble_Sort(arr)
{
    bubble_counter = 0;
    var unsorted = true;
    var size = arr.length - 1;
    var result = copy_array(arr);
    do
    {
        unsorted = false;
        for (var i=0; i < size; i++)
        {
                if (result[i] > result[i+1])
                {
                    swap(result, i, i+1);
                    unsorted = true;
                    bubble_counter++;
                }
        }
        size--;
    }
    while (unsorted);


}

// Insertion sort
async function insertion_Sort_Visual(ar)
{
    stop = false; // Stop tracker, is set true stop iterations through sorted array
    reset_counters(); // Reset counters
    update_counters(); // Update value on page
    var arr = copy_array(ar);
    var size = arr.length;
    insertion_counter = 0;
    // Iterate over the array
    for (let i = 0; i<size; i++)
    {
        if (stop) {break;}
        let elt = arr[i];
        document.getElementById("11").innerHTML = elt.toString();
        let j;
        for (j=i-1; j>=0 && arr[j]>elt; j--)
        {
            if (stop) {break;}
            highlight([i,j],"blue");
            await sleep(5*speed);
            arr[j+1]=arr[j];
            fill(arr);
            insertion_counter +=1;
            update_counters(); // Update value on page
        }
        arr[j+1] = elt;

        fill(arr);
        document.getElementById("11").innerHTML = '';
        await sleep(5*speed);
    }
    update_counters();
    c1 = copy_array(ar);
    c2 = copy_array(ar);
    c3 = copy_array(ar);
    console.log(a);
    b = bubble_Sort(c1);
    merge_counter = 0;
    b = merge_Sort(c2);
    c = quick_Sort(c3,0, c3.length-1);
    a = copy_array(arr);
    update_counters();
}


function insertion_Sort(arr)
{
    var size = arr.length;
    insertion_counter = 0;
    // Iterate over the array
    for (let i = 0; i<size; i++)
    {
        let elt = arr[i];
        let j;
        for (j=i-1; j>=0 && arr[j]>elt; j--)
        {
            arr[j+1]=arr[j];
            insertion_counter +=1;
        }
        arr[j+1] = elt;
    }
    document.getElementById("insertion result").innerHTML = insertion_counter;
}


// Merge
function merge(arr1, arr2){
  let result = []; // the array to hold results.
  let i = 0;
  let j = 0;

// as the pseudo-code implies, we have to loop through the
// arrays at the same time and it has to be done once.
// note that if one array completes its iteration, we will
// have to stop the while loop.

  while(i < arr1.length && j < arr2.length){
// compare the elements one at a time.
    if(arr1[i] > arr2[j]) {
      result.push(arr2[j]);
      j++;
    } else {
      result.push(arr1[i]);
      i++;
    }
    merge_counter++;
  }

  // these other while loops checks if there's some item left
 // in the arrays so that we can push their elements in the result array.
  while(i < arr1.length){
    result.push(arr1[i]);
    i++;
  }

  while(j < arr2.length){
    result.push(arr2[j]);
    j++;
  }

  return result;
}

function merge_Sort(arr){

// recursion base case
// it checks if the array length is less than or equal to 1.
// if that's the case return the arr else keep splicing.
  if(arr.length <= 1) return arr;
  // remember that we said merge sort uses divide and conquer
// algorithm pattern

// it firsts know the half point of the array.
  let halfPoint = Math.ceil(arr.length / 2);

// and then splice the array from the beginning up to the half point.
// but for the fact that merge sort needs the array to be of one element, it will keep splicing that half till it fulfills the condition of having one element array.

  let firstHalf = merge_Sort(arr.splice(0, halfPoint));

// second array from the half point up to the end of the array.
  let secondHalf = merge_Sort(arr.splice(-halfPoint));

// merge the array back and return the result.
// note that we are using the helper function we created above.
  return merge(firstHalf, secondHalf);
}

// Merge for visualization
function merge_Sort_Visual(arr){

// recursion base case
// it checks if the array length is less than or equal to 1.
// if that's the case return the arr else keep splicing.
  if(arr.length <= 1) return arr;
  // remember that we said merge sort uses divide and conquer
// algorithm pattern

// it firsts know the half point of the array.
  let halfPoint = Math.ceil(arr.length / 2);

// and then splice the array from the beginning up to the half point.
// but for the fact that merge sort needs the array to be of one element, it will keep splicing that half till it fulfills the condition of having one element array.

  let firstHalf = merge_Sort_Visual(arr.splice(0, halfPoint));

// second array from the half point up to the end of the array.
  let secondHalf = merge_Sort_Visual(arr.splice(-halfPoint));

// merge the array back and return the result.
// note that we are using the helper function we created above.
  //await sleep(10 * speed);
  fill(arr);
  return merge(firstHalf, secondHalf);
}

// Quicksort part of code
function partition(items, left, right) {
    var pivot   = items[Math.floor((right + left) / 2)], //middle element
        i       = left, //left pointer
        j       = right; //right pointer
    while (i <= j) {
        while (items[i] < pivot) {
            i++;
        }
        while (items[j] > pivot) {
            j--;
        }
        if (i <= j) {
            swap(items, i, j); //sawpping two elements
            quicksort_counter++;
            i++;
            j--;
        }
    }
    return i;
}
// To be called like var sortedArray = quickSort(items, 0, items.length - 1);
function quick_Sort(items, left, right) {
    var index;
    if (items.length > 1) {
        index = partition(items, left, right); //index returned from partition
        if (left < index - 1) { //more elements on the left side of the pivot
            quick_Sort(items, left, index - 1);
        }
        if (index < right) { //more elements on the right side of the pivot
            quick_Sort(items, index, right);
        }
    }
    return items;
}


function generateTable(table)
{
  let header = table.createTHead();
  let row = table.insertRow();
  row.className = 'table-default';
  let hrow = header.insertRow();
  for (var j = 0;j<10;j++ )
  {
    let hcell = hrow.insertCell();
    let htext = document.createTextNode((j).toString());
    let cell = row.insertCell();
    let text = document.createTextNode((10-j).toString());
    a[j] = 10-j;
    cell.appendChild(text);
    hcell.appendChild(htext);
    cell.id=(j+1).toString();
    hcell.className = 'table-dark';
  }
}

function generateTableIns(table)
{
  let header = table.createTHead();
  let row = table.insertRow();
  row.className = 'table-default';
  let hrow = header.insertRow();
  for (var j = 0;j<11;j++ )
  {
    let hcell = hrow.insertCell();
    let htext = document.createTextNode((j).toString());
    let cell = row.insertCell();
    let text = document.createTextNode((10-j).toString());
    if (j == 10)
    {
        hcell.appendChild(document.createTextNode('Buffer'));
        cell.appendChild(document.createTextNode(''));
    }
    else
    {
        cell.appendChild(text);
        hcell.appendChild(htext);
        a[j] = 10-j;

    }
    cell.id=(j+1).toString();
    hcell.className = 'table-dark';
  }
}
