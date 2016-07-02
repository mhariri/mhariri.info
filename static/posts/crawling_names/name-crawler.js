
var name_index = 1;
var page=1;
var alpha = 1;
var sindex = 1;

function _x(STR_XPATH) {
    var xresult = document.evaluate(STR_XPATH, document, null, XPathResult.ANY_TYPE, null);
    var xnodes = [];
    var xres;
    while (xres = xresult.iterateNext()) {
        xnodes.push(xres);
    }
    return xnodes;
}

function pad(num, size) {
    var s = num+"";
    while (s.length < size) s = "0" + s;
    return s;
}

function extract_name() {
    var namearr = {
          "name" : $(_x('//*[@id="ctl11_ctl07_ctl00_lbname"]')).text(),
          "gender" : $(_x('//*[@id="ctl11_ctl07_ctl00_lbsexcode"]')).text(),
          "meaning" : $(_x('//*[@id="ctl11_ctl07_ctl00_TxtBxmens"]')).text(),
          "vars": alpha + "," + page + "," + name_index
        };
    console.log(namearr);
    window.localStorage.setItem("name_" + pad(sindex,6), JSON.stringify(namearr));
    sindex ++;
    next_name();
}
function wait_and_extract_name() {
  if(!$(_x('//*[@id="ctl11_ctl07_ctl00_AjaxLoadingPanel1"]')).is(":visible") &&    $(_x('//*[@id="ctl11_ctl07_ctl00_TxtBxmens"]')).is(":visible")) {
    extract_name();
  }else{
    window.setTimeout(wait_and_extract_name, 100);
  }
}

function next_name() {
    if(name_index > 12) {
      name_index = 1;
      next_page();
    }else {
      name_index ++;
      eval($(_x('//*[@id="ctl11_ctl07_ctl00_Listnam_ctl'+pad(name_index, 2)+'_LinkButton1"]')).attr('href'));
    }
    wait_and_extract_name();
}


function next_page() {
  page ++;
  if(page != 1 && _x('//*[@id="ctl11_ctl07_ctl00_Listnam"]/tbody/tr').length < 14){
    next_alpha();
    page = 0;
  }else{
    eval("AjaxNS.AR('ctl11$ctl07$ctl00$Listnam','Page$" + page + "', 'ctl11_ctl07_ctl00_RadAjaxPanel1', event)");
  }
}

function next_alpha() {
  if(alpha >= 33) {
    throw "Finished";
  }
  alpha ++;
  $(_x('//*[@id="ctl11_ctl07_ctl00_Bt' + alpha +'"]')).click();
}
