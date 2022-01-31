trigger reservation on Reservation__c (before insert,after update) {
       if (Trigger.isInsert) {
        Set<Id> SetReservationId = new Set<Id>();
        
        
        for(Reservation__c c :Trigger.New){
            if(c.Flat__c != null) 
            {
                SetReservationId.add(c.Flat__c);
            }
            if(SetReservationId.size() > 0 ) 
            {
                Map<Id, Flat__c> mapReservation = new Map<Id, Flat__c>([SELECT Id FROM Flat__c  WHERE Staus__c = 'Occupied']);
                for(Reservation__c cont: Trigger.new) 
                {
                    if(cont.Flat__c != null && mapReservation.containsKey(cont.Flat__c) ) 
                    {
                        cont.Flat__c.addError('Sorry the flat is already taken');
                        
                    }
                    else{
                        system.debug('it doesnt');
                    }
                }
            }
        }
    }
    if (Trigger.isUpdate){
        List<Flat__c> flats=new List<Flat__c>(); 
        List<Flat__c> new_flats=new List<Flat__c>(); 
        List<Reservation__c> reservation=New  List<Reservation__c>();
        List<Reservation__c> listCont=new List<Reservation__c>([Select Id,Status__c,Remaining_days__c,Flat__c from Reservation__c where Id in :Trigger.new]);
        List<Flat__c> ft=[Select Id,staus__c from Flat__c where Id =:listCont[0].Flat__c];
        
        
        for(Reservation__c cont :listCont){ 
           for(Flat__c f:ft){         
            if(cont.Status__c=='Approved'){
                if(cont.Remaining_days__c==0 || cont.Remaining_days__c<=6 ){
                   cont.Status__c='Renewal Stage';
                   reservation.add(cont);
                   system.debug('yelo');
               
                }
                  else{
                    f.Staus__c='Occupied';
                     flats.add(f);
                }
            }
                else if (cont.Status__c=='Closed' || cont.Status__c=='Available'  ) {
                   f.Staus__c='Available';
               
                   new_flats.add(f);
                    
                    
                }
               
              
        } 
        }
      
       
       
        
      if(reservation.size()>0) {                   
            update reservation;
        }
        
        if(flats.size()>0) {                   
            update flats;
        }
          if(new_flats.size()>0) {                   
            update new_flats;
        }
        
        
        
        
        
        
        
        
        
        
        
        
    }

}