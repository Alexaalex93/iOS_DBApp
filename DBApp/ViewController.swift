//
//  ViewController.swift
//  DBApp
//
//  Created by Alejandro Fernandez Gonzalez on 21/02/2017.
//  Copyright © 2017 Alejandro Fernandez Gonzalez. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
      var people:[NSManagedObject] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addName(_ sender: Any) {
        
        //PARA GUARDAR COSAS TENEMOS QUE METERNOS EN EL XCDTAMODEL Y DALTE A ADD EMPTY, LAS ENTIDADES SON COMO LAS CLASES PERO PARA EL MODELO DE DATOS
        let alert = UIAlertController(title: "Nuevo nombre", message: "Añadir nuevo nombre", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Guardar", style: .default) { (action) in
            guard let textField = alert.textFields?.first,
                let nombreAGuardar = textField.text else {
                    return
            }
            
            self.save(name: nombreAGuardar)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addTextField() //Al añadir el textfield se creara un campo de texto que se guardará en el array texfield al estar dentro de la funcion. Si solo creamos uno se guardará en la primera posición
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    func save(name: String){
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
        }//Primero accedemos a appdelegate, lo hacmeos con guard para que sea seguro y comprobamos si tenemos ese delegado de ese tipo, si no es asi salimos de ese delegado para que no nos de error
        let managedContext = appDelegate.persistentContainer.viewContext //ManageCOntext es el que organiza la informacion en CoreData
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)//Lo primero que le decimos es en que entidad queremos guardar la informacion
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)//Creamos el objeto para poder guardar
        person.setValue(name, forKeyPath: "name")// al objeto en su atributo nombre le pasamos la informacion
        //Para guardar el objeto debemos seguir la siguiente estructura
        do{
        
            try managedContext.save()
            people.append(person)
            
        } catch let error as NSError {
            print("Error al salvar")
        }
        
    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Mi lista"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")//Lo que le queremos pedir, queremos pedir el objeto. Dentro queremos acceder a la tabla llamada Person
        do{
        
            people = try managedContext.fetch(fetchRequest)//Con fetch le indicamos que es una peticion
        
        } catch let error as NSError {
        print("Error: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "name") as? String //En CoreData accedemos a las variables como si fuera un diccionario , entonces, accedemos al atributo y hacemos un casting
        
        return cell
    }


}

