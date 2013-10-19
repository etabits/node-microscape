var htmlparser = require('htmlparser2');
var _ = require('underscore')
var Entities = require('html-entities').AllHtmlEntities;
var entities = new Entities();

var blockLevelElements = ['address','article','aside','audio','blockquote','canvas','dd','div','dl','fieldset','figcaption','figure','figcaption','footer','form','h1','h2','h3','h4','h5','h6','header','hgroup','hr','noscript','ol','output','p','pre','section','table','tfoot','ul','video'];


var getText = function(elem){
    if(elem instanceof Array) {
        return elem.map(getText).join('\n\n')
    }
    if(htmlparser.DomUtils.isTag(elem)) {
        if('br'==elem.name) return '\n';
        if('p'==elem.name) return elem.children.map(getText).join("") + '\n\n\n';
        if(_.contains(blockLevelElements, elem.name)) return elem.children.map(getText).join("") + '\n';
        return elem.children.map(getText).join("")
    }
    if(elem.type === htmlparser.ElementType.Text) return entities.decode(elem.data.replace(/\n/g, ' ').trim());
    return "";  
};

module.exports = getText;