//
//  ViewController.swift
//  Sudoku
//
//  Created by Atholon on 2017/12/24.
//  Copyright © 2017年 Atholon. All rights reserved.
//////////////////////////////////////////////////////
//  解数独程序  //




import UIKit

class ViewController: UIViewController {
    
    var lastLabel : UILabel?          //之前选择的Label
    var sellectLabel : UILabel?       //现在选择的Label
    var mySudoku = Sudoku()           //数独类的对象实例

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        
        for i in 0 ... 80 {               //建立9*9=81个Label对象，作为数独格
            let label = UILabel()         //定义一个UILabel对象-label。
            //设置label的属性
            label.font = UIFont.systemFont(ofSize: 30)  //字体大小30
            label.text = ""
            label.textAlignment = .center
            label.backgroundColor = UIColor(red: 0,     //青色背景，全透明
                                            green: 1,
                                            blue: 1,
                                            alpha: 0)
            label.frame = CGRect(x: 8 + (i % 9) * 40,    //定位
                                 y: 73 + (i / 9) * 40,
                                 width: 40,
                                 height: 40)
            label.tag = i + 1      //设置tag为1-81
            
            
            label.isUserInteractionEnabled = true  //设置为可交互
            //添加点击手势，绑定 tapLabel 函数
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(ViewController.tapLabel(sender:))))
            self.view.addSubview(label)      //添加该label
        }
        
        
        
        for i in 1 ... 9 {            //建立9个Label对象，作为数字按键
            let label = UILabel()     //定义一个UILabel对象-label。
            //设置label的属性
            label.font = UIFont.systemFont(ofSize: 30) //字体大小30
            label.frame = CGRect(x: 9 + (i - 1) * 40,  //定位
                                 y: 73 + 9 * 40 + 10,
                                 width: 39,
                                 height: 39)
            label.tag = i + 100       //设置tag为101-109
            
            label.text = String(i)     //显示1-9
            label.backgroundColor = UIColor(red: 231/255,    //背景颜色
                                            green: 155/255,
                                            blue: 63/255,
                                            alpha: 1)
            label.textColor = UIColor(red: 231/255,           //文字颜色
                                      green: 6/255,
                                      blue: 16/255,
                                      alpha: 1)
            label.textAlignment = .center
            label.isUserInteractionEnabled = true             //设置为可交互
            
            //添加点击手势，绑定 tapNumberLabel 函数
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(ViewController.tapNumberLabel(sender:))))
            
            self.view.addSubview(label)  //添加该label
        }
        
        //设置左上角为默认选择和之前的选择，并设置青色背景
        sellectLabel = self.view.viewWithTag(1) as? UILabel
        lastLabel = sellectLabel
        sellectLabel?.backgroundColor = UIColor(red: 0,
                                                green: 1,
                                                blue: 1,
                                                alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //数独格点击处理函数
    @IBAction func tapLabel(sender:UITapGestureRecognizer){
        //通过tag定位被点击的label，绑定为选择的格
        sellectLabel = self.view.viewWithTag((sender.view?.tag)!) as? UILabel
        //取消上一格高亮
        lastLabel?.backgroundColor = UIColor(red: 0, green: 1, blue: 1, alpha: 0)
        //设置上一格为选择的格
        lastLabel = sellectLabel
        //设置被点击格高亮
        sellectLabel?.backgroundColor = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
    }
    
    //数字键点击处理函数
    @IBAction func tapNumberLabel(sender:UITapGestureRecognizer){
        let number = (sender.view?.tag)! - 100  //数字为 tag-100
        
        //设置选择格字体颜色为红并修改格数字
        sellectLabel?.textColor = UIColor(red: 231/255,
                                  green: 6/255,
                                  blue: 16/255,
                                  alpha: 1)
        sellectLabel?.text = String(number)
        
        //通过tag定位并修改数独数据数组
        let y = ((sellectLabel?.tag)! - 1) % 9
        let x = ((sellectLabel?.tag)! - 1) / 9
        mySudoku.SudokuData[x][y] = number
        mySudoku.SudokuBL[x][y] = true
    }
    
    //“清除”按钮处理函数
    @IBAction func EraseNumber(){
        //选择格字体颜色改回黑色，清除数字
        sellectLabel?.textColor = UIColor(red: 0,
                                          green: 0,
                                          blue: 0,
                                          alpha: 1)
        sellectLabel?.text = ""
        
        //通过tag定位并修改数独数据数组
        let y = ((sellectLabel?.tag)! - 1) % 9
        let x = ((sellectLabel?.tag)! - 1) / 9
        mySudoku.SudokuData[x][y] = 0
        mySudoku.SudokuBL[x][y] = false
    }
    
    //“计算”按钮处理函数
    @IBAction func Calculate(){
        if mySudoku.FillNumber(x: 0, y: 0,target:self) {  //如果“填数”函数成功
            DisplaySudoku()
        }
        
        
    }
    
    //显示数独函数
    @objc func DisplaySudoku() -> Void {
        for i in 0...8 {
            for j in 0...8 {
                if mySudoku.SudokuBL[i][j] == false {//仅修改未填的数
                    //通过tag逐个选定81个格，修改为数独数据
                    let label = self.view.viewWithTag(i * 9 + j + 1) as? UILabel
                    //label!.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                    label!.text = String(mySudoku.SudokuData[i][j])
                    
                }
            }
        }
        print(mySudoku.IteratTimes)//打印迭代次数
    }



}

