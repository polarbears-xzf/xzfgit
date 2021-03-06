1.	单个API执行情况分析
	*	获取req索引指定API指定时间按日/小时分组以日期为降序，统计平均执行时间，最大执行时间，最小执行时间及标准方差。以分析执行API执行稳定性
		GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
		      "must": [
		        {"match":{
			  "requestUri":"/dict/drug/getDrugList"  		
			}}
		      ], 
			  "filter": {
			    "range": {
			      "createTime": {
			        "gte": 1567209600000
			      }
			    }
			  }
		    }
		  },
		  "aggs": {
			"group_by_time": {
			  "date_histogram": {
				"field": "createTime",
				"interval": "day",
				"order": {
				  "_key": "desc"
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
		  }
		}
	*	获取req索引中指定API指定时间范围内按运行时间排序，以分析指定API异常执行时间情况
		GET /t_log_req/doc/_search
		{
		  "size":20,
		  "query": {
		    "bool": {
		      "must": [
		        {"match":{
			  "requestUri":"/dict/drug/getDrugList"  		
			}}
		      ], 
			  "filter": {
			    "range": {
			      "createTime": {
			        "gte": 1567209600000
			      }
			    }
			  }
		    }
		  },
		  "sort": [
		    {
		      "runTime": {
		        "order": "desc"
		      }
		    }
		  ],
		  "_source": ["createTime","ipAndPort","requestId","runTime"]
		}

2.	API总体执行情况分析
	*	获取req索引根据API分组按次数、总执行时间、平均运行时间、最大运行时间排序。以分析API使用量情况。
		GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
			  "must": {
			    "range": {
			      "createTime": {
			        "gte": 1467209600000,
			        "lt": 1667209600000
			      }
			    }
			  }
		    }
		  },
		  "aggs": {
			"terms_requestUri": {
			  "terms": {
				"field": "requestUri.keyword",
				"size": 10
			  },
			  "aggs": {
				"terms_ipAndPort": {
				  "terms": {
					"field": "ipAndPort.keyword",
					"size": 10
				  }, 
			  "aggs": {
				"stats_runTime": {
				  "extended_stats": {
					"field": "runTime"
				  }
				}
			  }
				}
			  }
			}
		  }
		}
	*	获取req索引指定时间范围直接按服务分组以平均执行时间为降序统计，以分析
		GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
			  "must": {
			    "range": {
			      "createTime": {
			        "gte": 1467209600000,
			        "lt": 1667209600000
			      }
			    }
			  }
		    }
		  },
		  "aggs": {
			"terms_ipAndPort": {
			  "terms": {
				"field": "ipAndPort.keyword",
				"size": 50
				, "order": {
				  "stats_runTime.avg": "desc"
				}
			  }, 
  		  "aggs": {
    			"stats_runTime": {
    			  "extended_stats": {
    				"field": "runTime"
    			  }
    			}
  		  }
		  }
		}
		}
	*	获取req索引指定时间范围以执行次数为降序按日分组，以分析
		GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
			  "must": {
			    "range": {
			      "createTime": {
			        "gte": 1567209600000,
			        "lt": 1667209600000
			      }
			    }
			  }
		    }
		  },
		  "aggs": {
			"terms_ipAndPort": {
			  "terms": {
				"field": "ipAndPort.keyword",
				"size": 50
				, "order": {
				  "_key": "desc"
				}
			  }, 
  		  "aggs": {
    			"date_createTime": {
    			  "date_histogram": {
    				"field": "createTime",
    				"interval": "day"
    			  }
    			}
  		  }
		  }
		}
		}
	*	获取指定某日按执行时间分组以最大执行时间为降序的API统计，以分析不同时间分布消耗时间最高API情况
		GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
			  "must": {
			    "range": {
			      "createTime": {
			        "gte": 1567209600000,
			        "lt": 1667209600000
			      }
			    }
			  }
		    }
		  },
		  "aggs": {
		    "date_createTime": {
		      "date_histogram": {
		        "field": "createTime",
		        "interval": "hour"
		      },
		      "aggs": {
    		    "term_sqlHash": {
    		      "terms": {
    		        "field": "requestUri.keyword",
    		        "order": {
    		          "stats_runTime.avg": "desc"
    		        }
    		      },
      		    "aggs": {
      		      "stats_runTime":{
      		        "extended_stats": {
      		          "field": "runTime"
      		        }
      		      }
      		    }
    		    }
		  }
		    }
		  }
		}
	*	获取req索引dict/drug/getDrugList按日分组以平均执行时间降序，以通过执行频繁最高的API分析日性能稳定性
		GET /t_log_req/doc/_search
		{
		  "size":0,
		  "query": {
		    "bool": {
		      "must": [
		        {"match":{
			  "requestUri":"/dict/drug/getDrugList"  		
			      }}
		      ]
		    }
		  },
		  "aggs": {
		    "date_createTime": {
		      "date_histogram": {
		        "field": "createTime",
		        "interval": "day",
		        "order": {
		          "_key": "desc"
		        }
		      },
		      "aggs": {
		        "avg_runTime": {
		          "avg": {
		            "field": "runTime"
		          }
		        }
		      }
		    }
		  }
		}


1.	获取警告索引中指定时间范围内执行时间大于0.5秒的SQL语句并按语句进行分组计数
	GET _search
	{
	  "size":0,
	  "query": {
		"bool":{
		  "must":[
			{"match": {"type":"sqlTimeout" }},
			{"range": {"runTime":{"gte":"0.5" }}},
					{"range": {"createTime":{"gte":"1565784138000","lte":"1566389106000" }}}
			]
		}
	  },
	  "aggs":{
		"group_by_sqlcontent":{
			"terms": {
			  "field": "taskHash.keyword",
			  "size": 10
			}
		}
	  }
	}
2.	获取sql索引中指定时间范围内执行时间大于0.5秒的SQL语句并按语句进行分组计数
	GET /t_log_sql/doc/_search
	{
	  "size":0,
	  "query": {
		"bool":{
		  "must":[
			{"range": {"runTime":{"gte":"500" }}},
					{"range": {"createTime":{"gte":"1565784138000","lte":"1566389106000" }}}
			]
		}
	  },
	  "aggs":{
		"group_by_sqlcontent":{
			"terms": {
			  "field": "sqlHash.keyword",
			  "size": 10
			}
		}
	  }
	}
3.	获取sql索引中指定时间范围内单个请求最大执行sql数
	GET /t_log_sql/doc/_search
	{
	  "size":0,
	  "query": {
		"bool":{
		  "must":[
			{"range": {"runTime":{"gte":"500" }}},
					{"range": {"createTime":{"gte":"1565784138000","lte":"1566389106000" }}}
			]
		}
	  },
	  "aggs":{
		"group_by_sqlcontent":{
			"terms": {
			  "field": "sqlHash.keyword",
			  "size": 10
			}
		}
	  }
	}
4.	获取sql索引中指定时间范围内指定SQL执行次数
	GET /t_log_sql/doc/_search
	{
	  "size":0,
	  "query": {
		"bool":{
		  "must":[
			{"match": {"sqlHash":"1E864B2EBD93A8311D63A3FDB5E2E5FE"}},
			{"range": {"createTime":{"gte":"1565784138000","lte":"1566389106000" }}}
			]
		}
	  }
	}

4.	获取req索引中请求平均执行时间
	GET /t_log_req/doc/_search
	{
	  "size":0,
	  "aggs":{
	    "group_by_request":{
	      "terms": {
	        "field": "requestUri.keyword",
	        "order": {"average_runtime.avg":"desc"}
			  },
			"aggs":{
				"average_runtime":{
					"extended_stats":{
						"field":"runTime"
					  }
				  }
			}
	    }
	  }
	  
	}
	
3.	获取req索引中指定时间范围内api请求次数排序
	GET /t_log_req/doc/_search
	{
	  "size":0,
	  "query": {
		"bool":{
		  "must":[
			{"range": {"runTime":{"gte":"1" }}},
					{"range": {"createTime":{"gte":"1465784138000","lte":"1766389106000" }}}
			]
		}
	  },
	  "aggs":{
  		"group_by_requestID":{
  			"terms": {
  			  "field": "requestUri.keyword",
  			  "size":20,
  			  "order":{"_count":"desc"}
  			}
  		}
	  }
	}

5.	获取执行api接口每日执行次数，按日期排序
	GET /t_log_req/doc/_search
	{
	  "size":0,
	  "query": {
  		"match":{
  		  "requestUri":"/inpatient/bed/bedDict/autoDeductBedFee"  		
  		}
	  },
	  "aggs": {
	    "group_by_time": {
	      "date_histogram": {
	        "field": "createTime",
	        "interval": "day"
	        , "order": {
	          "_key": "desc"
	        }
	      }
	    }
	  }
	}
4.	获取req索引中指定时间范围内执行次数超过10次的api平均运行时间排序，
	GET /t_log_req/doc/_search
	{
	  "size":0,
	  "query": {
		"bool":{
		  "must":[
			{"range": {"runTime":{"gte":"1" }}},
					{"range": {"createTime":{"gte":"1465784138000","lte":"1766389106000" }}}
			]
		}
	  },
	  "aggs":{
	    "group_by_request":{
	      "terms": {
	        "field": "requestUri.keyword",
	        "order": {"extended_runtime.avg":"desc"}
			  },
			"aggs":{
				"extended_runtime":{
					"extended_stats":{
						"field":"runTime"
					  }
				  },
				  "bulket_selector_count":{
				    "bucket_selector": {
				      "buckets_path": {
				        "extended_count":"extended_runtime.count"
				      },
				      "script": "params.extended_count > 10"
				    }
				  }
			}
	    }
	  }
	}
