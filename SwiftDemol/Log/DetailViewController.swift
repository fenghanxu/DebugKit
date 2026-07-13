//
//  DetailViewController.swift
//  SwiftDemol
//
//  Created by imac on 2026/7/13.
//

import UIKit
import SnapKit



class DetailViewController:UIViewController {



    private let model:FHXLogModel



    init(model:FHXLogModel){


        self.model = model


        super.init(
            nibName:nil,
            bundle:nil
        )

    }



    required init?(coder:NSCoder){

        fatalError()

    }





    lazy var scrollView:UIScrollView = {


        let scroll =
        UIScrollView()


        scroll.showsVerticalScrollIndicator =
        true


        return scroll

    }()




    lazy var contentView:UIView = {


        let view =
        UIView()


        return view


    }()





    lazy var levelLabel:UILabel = {


        let label =
        UILabel()


        label.textColor = .white


        label.textAlignment = .center


        label.layer.cornerRadius = 4


        label.clipsToBounds = true


        return label

    }()




    lazy var timeLabel:UILabel = {


        let label =
        UILabel()


        return label

    }()



    lazy var methodLabel:UILabel = {


        let label =
        UILabel()


        label.numberOfLines = 1


        return label

    }()




    lazy var contentLabel:UILabel = {


        let label =
        UILabel()


        label.font =
        UIFont.systemFont(
            ofSize:14
        )


        label.numberOfLines =
        0


        return label

    }()




    override func viewDidLoad(){


        super.viewDidLoad()


        view.backgroundColor =
        .white


        title = "日志详情"


        setupUI()


        bindData()


    }






    private func setupUI(){



        view.addSubview(scrollView)



        scrollView.snp.makeConstraints {

            make in

            make.edges.equalToSuperview()

        }




        scrollView.addSubview(contentView)



        contentView.snp.makeConstraints {

            make in

            make.top.left.right.equalToSuperview()

            make.width.equalTo(view)

        }






        contentView.addSubview(levelLabel)


        levelLabel.snp.makeConstraints {

            make in

            make.top.equalToSuperview()
                .offset(10)


            make.left.equalToSuperview()
                .offset(10)


            make.width.equalTo(60)


            make.height.equalTo(22)


        }






        contentView.addSubview(timeLabel)


        timeLabel.snp.makeConstraints {

            make in

            make.centerY.equalTo(levelLabel)

            make.left.equalTo(levelLabel.snp.right)
                .offset(10)

        }






        contentView.addSubview(methodLabel)



        methodLabel.snp.makeConstraints {

            make in


            make.top.equalTo(levelLabel.snp.bottom)
                .offset(5)


            make.left.right.equalToSuperview()
                .inset(10)

        }






        contentView.addSubview(contentLabel)



        contentLabel.snp.makeConstraints {

            make in


            make.top.equalTo(methodLabel.snp.bottom)
                .offset(5)


            make.left.right.equalToSuperview()
                .inset(10)


            make.bottom.equalToSuperview()
                .offset(-20)

        }



    }





    private func bindData(){



        levelLabel.text =
        "\(model.level)"



        levelLabel.backgroundColor =
        model.level.color




        timeLabel.text =
        model.timeString




        methodLabel.text =
        model.methodString




        contentLabel.text =
        model.message


    }


}
