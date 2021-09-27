//
//  PolicyViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/19.
//

import UIKit

class PolicyViewController: UIViewController {
    
    private let policyTextView1 = PolicyTextView(policyText: "お客さまよりお預かりした個人情報を適切に管理し、同意がある場合や法令に基づく開示の場合を除き、利用者情報を第三者に開示いたしません。")
    private let policyTextView2 = PolicyTextView(policyText: "お客さまの個人情報を正確かつ最新の状態に保ち、個人情報への不正アクセス・紛失・破損・改ざん・漏洩などを防止するため、安全対策を実施し個人情報の厳重な管理を行ないます。")
    private let policyTextView3 = PolicyTextView(policyText: "アプリの利便性向上のため、匿名で個人を特定できない範囲で最新の注意を払い、アクセス解析をしております。例えばアプリのクラッシュ時にどんな原因でクラッシュしたかを匿名で送信して、バグの素早い修正に役立たせております。")
    private let policyTextView4 = PolicyTextView(policyText: "保有する個人情報に関して適用される日本の法令、その他規範を遵守するとともに、本ポリシーの内容を適宜見直し、その改善に努めます。")
    private let policyTextView5 = PolicyTextView(policyText: "利用上の不具合・不都合に対して可能な限りサポートを行っておりますが、利用者が本アプリを利用して生じた損害に関して、開発元は責任を負わないものとします。")
    private let policytitleLabel1 = PolicyTitleLabel(title: "利用者情報の提供")
    private let policytitleLabel2 = PolicyTitleLabel(title: "個人情報の管理")
    private let policytitleLabel3 = PolicyTitleLabel(title: "データ解析")
    private let policytitleLabel4 = PolicyTitleLabel(title: "法令、規範の遵守と見直し")
    private let policytitleLabel5 = PolicyTitleLabel(title: "免責事項")
    
    private let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        let policyStackView1 = UIStackView(arrangedSubviews: [policytitleLabel1, policyTextView1])
        let policyStackView2 = UIStackView(arrangedSubviews: [policytitleLabel2, policyTextView2])
        let policyStackView3 = UIStackView(arrangedSubviews: [policytitleLabel3, policyTextView3])
        let policyStackView4 = UIStackView(arrangedSubviews: [policytitleLabel4, policyTextView4])
        let policyStackView5 = UIStackView(arrangedSubviews: [policytitleLabel5, policyTextView5])

        let stackViews = [policyStackView1,
                          policyStackView2,
                          policyStackView3,
                          policyStackView4,
                          policyStackView5]
        stackViews.forEach {
            $0.axis = .vertical
            $0.spacing = 5
            $0.anchor(height: 100)
        }

        let baseStackView = UIStackView(arrangedSubviews: [policyStackView1, policyStackView2, policyStackView3, policyStackView4, policyStackView5])
        baseStackView.axis = .vertical
        baseStackView.spacing = 10
        view.addSubview(baseStackView)
        policytitleLabel3.anchor(centerY: view.centerYAnchor)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, height: screenSize.height, leftPadding: 40, rightPadding: 40)
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
