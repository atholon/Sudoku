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
    //之前选择的Label
    var lastLabel : UILabel?
    //现在选择的Label
    var sellectLabel : UILabel?
    // 数独方格数组
    var sudokuLabels = [UILabel]()
    // 数字按钮数组
    var numLabels = [UILabel]()
    
    //数独类的对象实例
    var mySudoku = Sudoku()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        //建立9*9=81个Label对象，作为数独格
        for i in 0 ... 80 {
            sudokuLabels.append(UILabel())
            //let label = UILabel()         //定义一个UILabel对象-label。
            //设置label的属性
            //字体大小30
            sudokuLabels[i].font = UIFont.systemFont(ofSize: 30)
            sudokuLabels[i].text = ""
            sudokuLabels[i].textAlignment = .center
            //青色背景，全透明
            sudokuLabels[i].backgroundColor = UIColor(red: 0,
                                            green: 1,
                                            blue: 1,
                                            alpha: 0)
            //定位
            sudokuLabels[i].frame = CGRect(x: 8 + (i % 9) * 40,
                                           y: 73 + (i / 9) * 40,
                                           width: 40,
                                           height: 40)
            //设置 tag 为 1-81
            sudokuLabels[i].tag = i + 1
            
            //设置为可交互
            sudokuLabels[i].isUserInteractionEnabled = true
            //添加点击手势，绑定 tapLabel 函数
            sudokuLabels[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(tapLabel)))
            //添加该label
            self.view.addSubview(sudokuLabels[i])
        }
        
        
        //建立9个Label对象，作为数字按键
        for i in 0 ... 8 {
            // 添加一个数字按钮 label
            numLabels.append(UILabel())
            
            //let label = UILabel()     //定义一个UILabel对象-label。
            //设置label的属性
            //字体大小30
            numLabels[i].font = UIFont.systemFont(ofSize: 30)
            //定位
            numLabels[i].frame = CGRect(x: 9 + (i) * 40,
                                        y: 73 + 9 * 40 + 10,
                                        width: 39,
                                        height: 39)
            //设置tag为101-109
            numLabels[i].tag = i + 100 + 1
            
            //显示1-9
            numLabels[i].text = String(i + 1)
            //背景颜色
            numLabels[i].backgroundColor = UIColor(red: 231/255,
                                                   green: 155/255,
                                                   blue: 63/255,
                                                   alpha: 1)
            //文字颜色
            numLabels[i].textColor = UIColor(red: 231/255,           //文字颜色
                                             green: 6/255,
                                             blue: 16/255,
                                             alpha: 1)
            
            numLabels[i].textAlignment = .center
            //设置为可交互
            numLabels[i].isUserInteractionEnabled = true
            
            //添加点击手势，绑定 tapNumberLabel 函数
            numLabels[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(tapNumberLabel)))
            //添加该label
            self.view.addSubview(numLabels[i])
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
    
    /// “计算”按钮响应函数
    @IBAction func Calculate(){
        // 建立子线程派遣队列
        let queue = DispatchQueue(label: "suduku.fillnumber")
        // 在子线程中调用 fillNumber 函数，以便在主线程中更新UI
        queue.async {
            // 如果”填数“成功，显示结果，如果失败，打印”无解“
            if self.mySudoku.FillNumber(x: 0, y: 0,target:self) {
                // 在主线程中调用 DisplaySudoku 显示结果
                DispatchQueue.main.async {
                    self.DisplaySudoku()
                }
            }else{
                print("无解")
            }
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

