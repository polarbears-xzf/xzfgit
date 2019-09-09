1. 使用SQLDEV执行SQL获取unix时间
	select to_date('1970-01-01','yyyy-mm-dd') + 1567472400000/86400
	  + to_number(substr(tz_offset(sessiontimezone),1,3))/24 Unix_to_Oracle
	from dual;
	select (to_date('2019-09-02','yyyy-mm-dd') - to_date('1970-01-01','yyyy-mm-dd'))*86400 
	  - to_number(substr(tz_offset(sessiontimezone),1,3))*3600  Oracle_to_Unix
	from dual; 
2.	使用kibana获取t_log_req索引指定时间范围以应用服务分组执行次数
	HIS后端服务-8082/18082 ，	HIS收费API-6055，	HIS医嘱API-6054，	HIS医生API-6051
	HIS护士API-6052，	HIS模版API-6050，	HIS病案API-6057，	HIS票据API-6053，	
	HIS门诊API-6056 
	GET /t_log_req/doc/_search
	{
	  "size":0,
	  "query": {
		"bool": {
		  "must": [
			{"range": {
			  "createTime": {
				"gte": 1567526400000,
				"lte": 1567612800000
			  }
			}},
			{"match": {
			  "ipAndPort": "6055"
			}}
		  ]
		}
	  },
      "aggs": {
        "group_by_ipandport": {
          "terms": {
            "field": "ipAndPort.keyword",
            "size": 50
          }
          }
        }
      }
3.	使用kibana获取t_log_req索引指定时间范围以应用服务分组最大执行次数（按小时、按分钟）
	GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
  			  "must": [
  			    {"range": {
  			      "createTime": {
  			        "gte": 1567440000000,
  			        "lte": 1567526400000
  			      }
  			    }},
  			    {"match": {
  			      "ipAndPort": "18082"
  			    }}
  			  ]
		    }
		  },
      "aggs": {
        "group_by_ipandport": {
          "terms": {
            "field": "ipAndPort.keyword"
          },
          "aggs": {
            "date_createTime": {
              "date_histogram": {
                "field": "createTime",
                "interval": "hour/minute",
                "order": {
                  "_count": "desc"
                }
              }
            }
          }
          }
        }
      }
4.	使用kibana获取t_log_req索引指定时间范围以应用服务分组最大执行时间和平均执行时间
	医嘱服务
	GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
  			  "must": [
  			    {"range": {
  			      "createTime": {
  			        "gte": 1567526400000,
  			        "lte": 1567612800000
  			      }
  			    }},
  			    {"match": {
  			      "ipAndPort": "6054"
  			    }}
  			  ],
  			  "must_not": [
  			    {"match": {
  			      "operator": "jobs"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/pres/collate/collatePrescribes"
  			    }}
  			  ]
		    }
		  },
      "aggs": {
        "stat_runTime": {
          "extended_stats": {
            "field": "runTime"
          }
          }
        }
      }
	  收费服务
	  	GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
  			  "must": [
  			    {"range": {
  			      "createTime": {
  			        "gte": 1567526400000,
  			        "lte": 1567612800000
  			      }
  			    }},
  			    {"match": {
  			      "ipAndPort": "6055"
  			    }}
  			  ],
  			  "must_not": [
  			    {"match": {
  			      "operator": "jobs"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/dict/deduct/deduct/deductAllBill"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/reservation/scheduleTemplManager/createDoctorSchedule"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/dict/deduct/deduct/deductBatchBill"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/insur/insurManager/insurInterface"
  			    }}
  			  ]
		    }
		  },
      "aggs": {
        "stat_runTime": {
          "extended_stats": {
            "field": "runTime"
          }
          }
        }
      }
	  后台服务
	  GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
  			  "must": [
  			    {"range": {
  			      "createTime": {
  			        "gte": 1567526400000,
  			        "lte": 1567612800000
  			      }
  			    }},
  			    {"match": {
  			      "ipAndPort": "6055"
  			    }}
  			  ],
  			  "must_not": [
  			    {"match": {
  			      "operator": "jobs"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/dict/deptUser/addUserForDept"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/i18n/dictLanguageInfo/refreshCache"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/sys/param/refreshCache"
  			    }}
  			  ]
		    }
		  },
      "aggs": {
        "stat_runTime": {
          "extended_stats": {
            "field": "runTime"
          }
          }
        }
      }
	  护士服务
	  GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
  			  "must": [
  			    {"range": {
  			      "createTime": {
  			        "gte": 1567526400000,
  			        "lte": 1567612800000
  			      }
  			    }},
  			    {"match": {
  			      "ipAndPort": "6052"
  			    }}
  			  ],
  			  "must_not": [
  			    {"match": {
  			      "operator": "jobs"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/emr/nursingTemperature/batchSave"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/emr/nursingTemperature/getBatchPatient"
  			    }}
  			  ]
		    }
		  },
      "aggs": {
        "stat_runTime": {
          "extended_stats": {
            "field": "runTime"
          }
          }
        }
      }
5.	使用kibana获取t_log_req索引指定时间范围指定服务消耗时间降序排列
	GET /t_log_req/doc/_search
		{
		  "size":10,
		  "query": {
		    "bool": {
  			  "must": [
  			    {"range": {
  			      "createTime": {
  			        "gte": 1567526400000,
  			        "lte": 1567612800000
  			      }
  			    }},
  			    {"match": {
  			      "ipAndPort": "6054"
  			    }}
  			  ],
  			  "must_not": [
  			    {"match": {
  			      "operator": "jobs"
  			    }},
  			    {"match_phrase": {
  			      "requestUri": "/pres/collate/collatePrescribes"
  			    }}
  			  ]
		    }
		  },
		  "sort": [
		    {
		      "runTime": {
		        "order": "desc"
		      }
		    }
		  ],
		  "_source": ["createTime","ipAndPort","operator","requestId","requestUri","runTime"]
      }

6.	使用kibana获取t_log_req索引指定时间范围TOP 10平均执行时间、总执行时间、最大执行时间的API
	GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
  			  "must": [
  			    {"range": {
  			      "createTime": {
  			        "gte": 1567612800000,
  			        "lte": 1567699200000
  			      }
  			    }}
  			  ]
		    }
		  },
		  "aggs": {
		    "group_by_uri": {
		      "terms": {
		        "field": "requestUri.keyword",
		        "size": 10,
		        "order": {
		          "stat_runTime.max": "desc"
		        },
		        "min_doc_count": 10
		      }, 
      "aggs": {
        "stat_runTime": {
          "extended_stats": {
            "field": "runTime"
          }
          }
        }
		    }
		  }
      }
