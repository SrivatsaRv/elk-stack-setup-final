## Checklist for Valid Capability of Pipeline

- Run `verify_access_health.sh` before demo-ing , so you know you are sorted
- Very your gitlab runner is status with `gitlab-runner status` and get a green signal there
- Ensure `generate_requests.sh` has been running, and you have setup `Discover` and any other visuals necessary in your Kibana
- Beofre demo-ing with pipelines , run `deploy_watcher_to_es.py` and `deploy_rules_to_kibana.py` in local and check
- 



### Demo Order:

**During introduction (~ 2-3 minutes)**
- Clean slate - show them nothing exists in Watcher and Rules 
- Introduce Repository Structure 
- Lay out scenarios you have catered for - combinations , and edge cases we currently cover
- Mention upfront what it does not have capability for 


**Start Demonstration: (~ 5 minutes)**
- Note - Number of pipelines to run - With Watcher , With Rules , Both - TOTAL 3 pipelines


**Scenarios to cater for: Alert Creation and Updated Flow**
- Create watcher , and push to main  |  Result - watcher created
- Create rule , and push to main     |  Result - rule created , show UI in Kibana - Take them through rule body and what it does (Opsgenie refernece)
- Update watcher and try duplicate   |  Result - watcher updated, re-attempt does not allow duplicate - just updates for same id if it exists
- Upadte rule , and try duplicate    |  Result - rule updated, re-attempt does not allow duplicate - just updates for same id if it exists
- Show Opsgenie Setup                |  Result - Alert triggered, hit Opsgenie and created an event , Phone call received 
- Show  Alert Body Proposed          |  Result - Parameterised alerts should be present , and have our alert body proposed + Runbook format
- Wrap up demo - with conclusion , and intent to take up the first alert rule to production
    - Show any architecture diagrams if necessary that you have ready
- Provide links - Master documentation with Flow, and Architecture Diagrams, Onboarding Documentation



**Future improvements**
- Bulk Upload of Rules when a new application onboards - (Team A sent SRE Team 5 alert rules - our pipeline will apply them in bulk)
- Improved Idempotency - Within 1st month of deployment , accomodate edge cases that would have come up 
- Basic Drift Detection - Ensure , rules cretaed by pipelines - always are in system , alert if they're tampered , or deleted , provide option to re-create with approval 
- Kibana Index - Used for Reporting As Well - the index being written to from where thresholds are being set, also provides watcher related metadata
