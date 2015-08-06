//
//  Constants.h
//  Hromadske
//
//  Created by Admin on 18.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

typedef enum {
    NewsDetailsModeDay = 0,
    NewsDetailsModeNight,
    NewsDetailsModeNone
} NewsDetailsMode;

static NSString* const API_GOOGLE = @"AIzaSyCbYvIR377tNF-b7Flggn5r0N3A0qzVPyE";
static NSString* const API_URL = @"http://178.62.205.247/v1/";
static NSString* const ARTICKE_JSON = @"http://178.62.205.247/v1/articles";
static NSString* const TEAM_JSON = @"http://178.62.205.247/v1/info/team";
static NSString* const DONATE_JSON = @"http://178.62.205.247/v1/info/donate";
static NSString* const CONTACTS_JSON = @"http://178.62.205.247/v1/info/contacts";
static NSString* const DIGEST_JSON = @"http://178.62.205.247/v1/info/digest";
static NSString* const HELP_URL = @"http://hromadske.cherkasy.ua/dopomogti";

static NSString* const HROMADSKE_URL = @"http://hromadske.cherkasy.ua";

static NSString* const HTMLDETAILS_DAY = @"<!DOCTYPE html><html><head><meta charset='UTF-8'><meta content='width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;' name='viewport' /><meta name='viewport' content='width=device-width' /><style>body,body html,html{width:100%;height:100%;}body{color:#000}a,checkbox,dd,div,dl,dt,em,fieldset,form,h1,h2,h3,h4,h5,h6,img,input,label,li,ol,p,select,span,strong,table,td,textarea,tr,ul{padding:0;margin:0;outline:0;list-style:none}input,select,textarea{font-size:12px;font-family:Arial,sans-serif;vertical-align:middle}textarea{vertical-align:top}:focus{outline:0}input[type=submit]{cursor:pointer}table{border-collapse:collapse;border-spacing:0}a{font-size:12px;font-family:Arial,sans-serif;color:#00f;text-decoration:none;cursor:pointer}a:hover{text-decoration:underline;cursor:pointer}a,abbr,acronym,address,applet,big,blockquote,body,caption,cite,code,dd,del,dfn,div,dl,dt,em,fieldset,font,form,h1,h2,h3,h4,h5,h6,html,iframe,img,ins,kbd,label,legend,li,object,ol,p,pre,q,s,samp,small,span,strike,strong,sub,sup,table,tbody,td,tfoot,th,thead,tr,tt,ul,var{margin:0;padding:0;border:0;outline:0;vertical-align:baseline}caption,td,th{text-align:left;font-weight:400}blockquote:after,blockquote:before,q:after,q:before{content:' '}blockquote,q{quotes:' '}body{color:#332F24!important;background:#E8E8E8!important;text-align:left!important;font-size:18px!important;font-family:HoeflerText-Regular,Georgia!important}.wrap{padding:20px}.wrap .itemHeader .itemTitle{padding:0 0 17px;margin:0 0 20px;border-bottom:1px solid #DCDCDC;color:#332F24!important;font-size:24px!important;line-height:33px!important;font-family:Superclarendon-Bold,Georgia-Bold!important}.wrap .itemVideoBlock{margin:0 0 20px}.wrap .itemVideoBlock iframe{width:100%!important;height:200px!important}.wrap .itemBody p{font-size:18px!important;line-height:24px;margin:0 0 10px}.wrap .itemBody b,.wrap .itemBody strong{font-weight:700!important}.wrap .itemBody table{width:100%;}.wrap .itemBody table td{width:auto!important}.wrap .itemBody p a{text-decoration:underline; color:#332F24; font-size:inherit;}.wrap .itemBody p img{max-width:100%;}.wrap .itemBody iframe{width:100%!important;height:300px!important;}</style></head><body><div class='wrap'>";

static NSString* const HTMLDETAILS_NIGHT = @"<!DOCTYPE html><html><head><meta charset='UTF-8'><meta content='width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;' name='viewport' /><meta name='viewport' content='width=device-width' /><style>body,body html,html{width:100%;height:100%;}body{color:#000}a,checkbox,dd,div,dl,dt,em,fieldset,form,h1,h2,h3,h4,h5,h6,img,input,label,li,ol,p,select,span,strong,table,td,textarea,tr,ul{padding:0;margin:0;outline:0;list-style:none}input,select,textarea{font-size:12px;font-family:Arial,sans-serif;vertical-align:middle}textarea{vertical-align:top}:focus{outline:0}input[type=submit]{cursor:pointer}table{border-collapse:collapse;border-spacing:0}a{font-size:12px;font-family:Arial,sans-serif;color:#00f;text-decoration:none;cursor:pointer}a:hover{text-decoration:underline;cursor:pointer}a,abbr,acronym,address,applet,big,blockquote,body,caption,cite,code,dd,del,dfn,div,dl,dt,em,fieldset,font,form,h1,h2,h3,h4,h5,h6,html,iframe,img,ins,kbd,label,legend,li,object,ol,p,pre,q,s,samp,small,span,strike,strong,sub,sup,table,tbody,td,tfoot,th,thead,tr,tt,ul,var{margin:0;padding:0;border:0;outline:0;vertical-align:baseline}caption,td,th{text-align:left;font-weight:400}blockquote:after,blockquote:before,q:after,q:before{content:''}blockquote,q{quotes:' '}body{color:#DBDBDB!important;background:#1E1E1E!important;text-align:left!important;font-size:18px!important;font-family:HoeflerText-Regular,Georgia!important}.wrap{padding:20px}.wrap .itemHeader .itemTitle{padding:0 0 17px;margin:0 0 20px;border-bottom:1px solid #292929;color:#DBDBDB!important;font-size:24px!important;line-height:33px!important;font-family:Superclarendon-Bold,Georgia-Bold!important}.wrap .itemVideoBlock{margin:0 0 20px}.wrap .itemVideoBlock iframe{width:100%!important;height:200px!important}.wrap .itemBody p{font-size:18px!important;line-height:24px;margin:0 0 10px}.wrap .itemBody b,.wrap .itemBody strong{font-weight:700!important}.wrap .itemBody table{width:100%;}.wrap .itemBody table td{width:auto!important}.wrap .itemBody p a{text-decoration:underline; color:#DBDBDB; font-size:inherit;}.wrap .itemBody p img{max-width:100%;}.wrap .itemBody iframe{width:100%!important;height:300px!important;}</style></head><body><div class='wrap'>";

static NSString* const HTMLDETAILS_WRAP = @"</div></body></html>";

static NSString* const HTML_CONTENT_WITH_IMAGE = @"<div class='itemHeader'><h2 class='itemTitle'>%@</h2></div><div class='itemBody'><div class='itemIntroText'>%@<p>%@</p></div></div>";

static NSString* const HTMLITEMIMAGE = @"<p><img src='%@'/></p>";
