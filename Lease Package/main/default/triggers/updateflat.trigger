trigger updateflat on Flat__c (before update) {
    List<Flat__c> flats=new List<Flat__c>([Select Id, Name,Staus__c,Flat_Number__c,(Select Id,Status__c from Reservation__r) from Flat__c where Id in :Trigger.new]); 
   
    
  
    
}