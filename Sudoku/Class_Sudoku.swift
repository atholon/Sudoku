//
//  Class_Sudoku.swift
//  Sudoku
//
//  Created by Atholon on 2017/12/25.
//  Copyright © 2017年 Atholon. All rights reserved.
//
import UIKit
import Foundation

//数独类
class Sudoku{
    //数字数组
    var SudokuData = [[Int]](repeating: [Int](repeating: 0, count: 10), count: 10)
    
    //是否题目数字的数据数组，true代表是题目数字
    var SudokuBL = [[Bool]](repeating: [Bool](repeating: false, count: 10), count: 10)
    
    var IteratTimes:Int  //迭代计数器
    
    //构造函数：迭代计数器归零
    init(){
        IteratTimes = 0
        
        /*
        for i in 0...8{
            for j in 0...8{
                print(SudokuData.count)
                print(j)
                SudokuBL[j][i] = false
                SudokuData[j][i] = 0
            }
        }*/
    }
    
    //填数字函数（核心）
    func FillNumber( x:Int, y:Int,target:AnyObject) -> Bool {
        //重新定义变量x,y
        var y = y
        var x = x
        
        IteratTimes += 1                     //迭代计数
        print(IteratTimes)
        
        //移动到非题目数字
        while SudokuBL[x][y] {
            MoveXY(x:&x, y:&y, d:1)
        }
        
        //仅迭代过程中，y<0说明无解
        if y < 0 {
           print("无解")
           return false
        }
        
        //仅迭代过程中，y>8说明计算完成
        if y > 8 {
            return true
        }
        
        
        var m = true                   //判断是否重复数字，ture为重复或0（未填数字）
        while m {
            SudokuData[x][y] += 1      //重数或0，数字+1
            //target.performSelector(onMainThread: #selector(ViewController.DisplaySudoku), with: nil, waitUntilDone: true)
            //如果数字大于9，说明1-9均无效，前面有错误，返回上一迭代
            if (SudokuData[x][y] > 9) {
                SudokuData[x][y] = 0
                if x == 0 && y == 0 {
                    print("无解")
                }
                return false
            }
            
            //临时x1,y1
            var x1 = 0
            var y1 = 0
            
            m = false               //先假设无重复
            for  i in 0...8 {
                //判断x轴是否有重复
                if (i != x) && (SudokuData[i][y] == SudokuData[x][y]) {
                    m = true
                    break
                }
                
                //判断y轴是否有重复
                if (i != y) && (SudokuData[x][i] == SudokuData[x][y]) {
                    m = true
                    break
                }
                
                //计算3*3格x1,y1坐标
                x1 = (x / 3) * 3 + i % 3;
                y1 = (y / 3) * 3 + i / 3;
                
                //判断3*3格中是否有重复
                if (x1 != x || y1 != y) && (SudokuData[x1][y1] == SudokuData[x][y]) {
                    m = true
                    break
                }
            }
            
            //如果无重复，移动到下一个，进行迭代调用
            if !m {
                MoveXY(x:&x, y:&y, d:1)
                
                //如果迭代调用失败，移动到上一格，进行下一次循环（数字+1）
                if (!FillNumber(x:x, y:y,target:target)) {
                    m = true
                    MoveXY(x: &x, y: &y, d: -1)
                }
            }
        }
        return true
    }
    
    //移动函数
    func MoveXY( x:inout Int, y:inout Int, d:Int){
        repeat {                   //先移动一格
            if d == 1 {            //向后移动
                if x < 8 {         //x没到尽头，x+1
                    x += 1
                }
                else {             //x到尽头，x回0，y+1
                    x = 0
                    y += 1
                    
                }
            }
            else {                  //向前移动
                if (x > 0) {        //x没到前尽头，x-1
                    x -= 1
                }
                else {              //x到前尽头，x回尾部，y-1
                    x = 8
                    y -= 1
                    
                }
            }
            if y > 8 || y < 0 {     //y>8:计算完成，y<0：无解
                return
            }
            
        } while SudokuBL[x][y] == true   //如果移动后是题目格，继续移动
    
    }
}






