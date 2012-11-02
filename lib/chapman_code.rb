# Copyright 2012 Trustees of FreeBMD
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
module ChapmanCode

  
  def self.values
    CODES::values
  end
  
  def self.select_hash
    CODES
  end
  
  def self.select_hash_with_parenthetical_codes
    Hash[ChapmanCode::CODES.map { |k,v| ["#{k} (#{v})", v] }]
  end
  
  CODES = {
    'Bedfordshire' => 'BDF',
    'Berkshire' => 'BRK',
    'Buckinghamshire' => 'BKM',
    'Cambridgeshire' => 'CAM',
    'Cheshire' => 'CHS',
    'Cornwall' => 'CON',
    'Cumberland' => 'CUL',
    'Derbyshire' => 'DBY',
    'Devonshire' => 'DEV',
    'Dorset' => 'DOR',
    'Durham' => 'DUR',
    'Essex' => 'ESS',
    'Gloucestershire' => 'GLS',
    'Hampshire' => 'HAM',
    'Herefordshire' => 'HEF',
    'Hertfordshire' => 'HRT',
    'Huntingdonshire' => 'HUN',
    'Isle of Wight' => 'IOW',
    'Kent' => 'KEN',
    'Lancashire' => 'LAN',
    'Leicestershire' => 'LEI',
    'Lincolnshire' => 'LIN',
    'London' => 'LND',
    'Middlesex' => 'MDX',
    'Norfolk' => 'NFK',
    'Northamptonshire' => 'NTH',
    'Northumberland' => 'NBL',
    'Nottinghamshire' => 'NTT',
    'Oxfordshire' => 'OXF',
    'Rutland' => 'RUT',
    'Shropshire' => 'SAL',
    'Somerset' => 'SOM',
    'Staffordshire' => 'STS',
    'Suffolk' => 'SFK',
    'Surrey' => 'SRY',
    'Sussex' => 'SSX',
    'Warwickshire' => 'WAR',
    'Westmorland' => 'WES',
    'Wiltshire' => 'WIL',
    'Worcestershire' => 'WOR',
    'Yorkshire' => 'YKS',
    'Yorkshire East Riding' => 'ERY',
    'Yorkshire North Riding' => 'NRY',
    'Yorkshire West Riding' => 'WRY',
    'Aberdeenshire' => 'ABD',
    'Angus' => 'ANS',
    'Argyllshire' => 'ARL',
    'Ayrshire' => 'AYR',
    'Banffshire' => 'BAN',
    'Berwickshire' => 'BEW',
    'Bute' => 'BUT',
    'Caithness' => 'CAI',
    'Clackmannanshire' => 'CLK',
    'Dumfriesshire' => 'DFS',
    'Dunbartonshire' => 'DNB',
    'East Lothian' => 'ELN',
    'Fife' => 'FIF',
    'Angus' => 'ANS',
    'Inverness-shire' => 'INV',
    'Kincardineshire' => 'KCD',
    'Kinross-shire' => 'KRS',
    'Kirkcudbrightshire' => 'KKD',
    'Lanarkshire' => 'LKS',
    'Midlothian' => 'MLN',
    'Moray' => 'MOR',
    'Nairnshire' => 'NAI',
    'Orkney' => 'OKI',
    'Peeblesshire' => 'PEE',
    'Perthshire' => 'PER',
    'Renfrewshire' => 'RFW',
    'Ross and Cromarty' => 'ROC',
    'Roxburghshire' => 'ROX',
    'Selkirkshire' => 'SEL',
    'Shetland' => 'SHI',
    'Stirlingshire' => 'STI',
    'Sutherland' => 'SUT',
    'West Lothian' => 'WLN',
    'Wigtownshire' => 'WIG',
    'Borders' => 'BOR',
    'Central' => 'CEN',
    'Dumfries and Galloway' => 'DGY',
    'Fife' => 'FIF',
    'Grampian' => 'GMP',
    'Highland' => 'HLD',
    'Lothian' => 'LTN',
    'Orkney Isles' => 'OKI',
    'Shetland Isles' => 'SHI',
    'Strathclyde' => 'STD',
    'Tayside' => 'TAY',
    'Western Isles' => 'WIS',
    'Anglesey' => 'AGY',
    'Brecknockshire' => 'BRE',
    'Caernarfonshire' => 'CAE',
    'Cardiganshire' => 'CGN',
    'Carmarthenshire' => 'CMN',
    'Denbighshire' => 'DEN',
    'Flintshire' => 'FLN',
    'Glamorgan' => 'GLA',
    'Merionethshire' => 'MER',
    'Monmouthshire' => 'MON',
    'Montgomeryshire' => 'MGY',
    'Pembrokeshire' => 'PEM',
    'Radnorshire' => 'RAD',
    'Clwyd' => 'CWD',
    'Dyfed' => 'DFD',
    'Gwent' => 'GNT',
    'Gwynedd' => 'GWN',
    'Mid Glamorgan' => 'MGM',
    'Powys' => 'POW',
    'South Glamorgan' => 'SGM',
    'West Glamorgan' => 'WGM'
  }
end